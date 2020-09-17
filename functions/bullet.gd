extends Node

const BULLET_PARTICLES = preload("res://scenes/bullet/bullet_particles.tscn")

var shoot_bullets = funcref(self, "_shoot_bullets")
var new_bullet_from_node = funcref(self, "_new_bullet_from_node")
var is_bullet = funcref(self, "_is_bullet")
var delete_on_collide = funcref(self, "_delete_on_collide")
var spawn_bullet_particles_on_destroy = funcref(self, "_spawn_bullet_particles_on_destroy")
var delete_on_timer = funcref(self, "_delete_on_timer")

static func _shoot_bullets(objects: Dictionary, world: Node) -> Array:
    var new_objects = []
    for ship_id in objects.keys():
        var ship = objects[ship_id]
        if not Ship._is_ship(0, ship): continue
        if not Ship._is_ready_to_fire(ship): continue
        if ship.input.fire:
            var new_bullet = SceneMap.get_scene("Bullet").instance()
            world.add_child(new_bullet)
            new_bullet.position = ship.gun.global_position
            new_bullet.rotation = ship.gun.global_rotation
            new_bullet.linear_velocity = Vector2(0, -800).rotated(ship.gun.global_rotation)
            new_bullet.linear_velocity += ship.linear_velocity
            new_bullet.spawn_sound.play()
            new_objects.append(_new_bullet_from_node(new_bullet, ship_id))
    return new_objects

static func _new_bullet_from_node(bullet_node: Node, ship_id) -> Dictionary:
    var bullet = NodeFunc._to_dictionary(bullet_node)
    bullet["destroy_timer"] = bullet_node.destroy_timer
    bullet["destroy_time"] = bullet_node.destroy_time
    bullet = Collision._add_collision_exception(bullet, ship_id)
    return bullet

static func _is_bullet(object: Dictionary) -> bool:
    return "type" in object and object.type == "Bullet"

static func _delete_on_collide(_key: int, object: Dictionary) -> Dictionary:
    if _is_bullet(object) and Collision._has_collision(object):
        object = object.duplicate()
        object["queue_delete"] = true
    return object

static func _spawn_bullet_particles_on_destroy(key: int, object: Dictionary, world: Node) -> Dictionary:
    if _is_bullet(object) and NodeFunc._is_queue_delete(key, object):
        var bullet_particles = BULLET_PARTICLES.instance()
        bullet_particles.emitting = true
        bullet_particles.global_position = object.position
        world.add_child(bullet_particles)
    return object

static func _delete_on_timer(_key: int, object: Dictionary, delta: float) -> Dictionary:
    if _is_bullet(object):
        object = object.duplicate()
        object.destroy_timer += delta
        if object.destroy_timer >= object.destroy_time:
            object["queue_delete"] = true
    return object
