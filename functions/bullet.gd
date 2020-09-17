class_name BulletFunctions

const BULLET_PARTICLES = preload("res://scenes/bullet/bullet_particles.tscn")
const COLLISION = CollisionFunctions
const COLLISION_EXCEPTION = CollisionExceptionFunctions
const NODE = NodeFunctions
const QUEUE_FREE = QueueFreeFunctions
const SHIP = ShipFunctions

static func shoot_bullets(objects: Dictionary, world: Node) -> Array:
    var new_objects = []
    for ship_id in objects.keys():
        var ship = objects[ship_id]
        if not SHIP.is_ship(0, ship): continue
        if not SHIP.is_ready_to_fire(ship): continue
        if ship.input.fire:
            var new_bullet = SceneMap.get_scene("Bullet").instance()
            world.add_child(new_bullet)
            new_bullet.position = ship.gun.global_position
            new_bullet.rotation = ship.gun.global_rotation
            new_bullet.linear_velocity = Vector2(0, -800).rotated(ship.gun.global_rotation)
            new_bullet.linear_velocity += ship.linear_velocity
            new_bullet.spawn_sound.play()
            new_objects.append(new_bullet_from_node(new_bullet, ship_id))
    return new_objects

static func new_bullet_from_node(bullet_node: Node, ship_id) -> Dictionary:
    var bullet = NODE.to_dictionary(bullet_node)
    bullet["destroy_timer"] = bullet_node.destroy_timer
    bullet["destroy_time"] = bullet_node.destroy_time
    bullet = COLLISION_EXCEPTION.add_collision_exception(bullet, ship_id)
    return bullet

static func is_bullet(object: Dictionary) -> bool:
    return "type" in object and object.type == "Bullet"

static func delete_on_collide(_key: int, object: Dictionary) -> Dictionary:
    if is_bullet(object) and COLLISION.has_collision(object):
        object = object.duplicate()
        object["queue_free"] = true
    return object

static func spawn_bullet_particles_on_destroy(key: int, object: Dictionary, world: Node) -> Dictionary:
    if is_bullet(object) and QUEUE_FREE.is_queue_free(key, object):
        var bullet_particles = BULLET_PARTICLES.instance()
        bullet_particles.emitting = true
        bullet_particles.global_position = object.position
        world.add_child(bullet_particles)
    return object

static func delete_on_timer(_key: int, object: Dictionary, delta: float) -> Dictionary:
    if is_bullet(object):
        object = object.duplicate()
        object.destroy_timer += delta
        if object.destroy_timer >= object.destroy_time:
            object["queue_free"] = true
    return object
