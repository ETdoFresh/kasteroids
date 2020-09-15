class_name BulletFunctions

const COLLISION = CollisionFunctions
const NODE = NodeFunctions
const SHIP = ShipFunctions

static func shoot_bullets(objects: Array, world: Node) -> Array:
    var new_objects = objects.duplicate()
    for i in range(objects.size()):
        var ship = objects[i].duplicate()
        if not SHIP.is_ship(ship): continue
        if not SHIP.is_ready_to_fire(ship): continue
        if ship.input.fire:
            ship.cooldown_timer = ship.cooldown
            new_objects[i] = ship
            var new_bullet = SceneMap.get_scene("Bullet").instance()
            world.add_child(new_bullet)
            new_bullet.position = ship.gun.global_position
            new_bullet.rotation = ship.gun.global_rotation
            new_bullet.linear_velocity = Vector2(0, -800).rotated(ship.gun.global_rotation)
            new_bullet.spawn_sound.play()
            new_objects.append(NODE.to_dictionary(new_bullet))
    return new_objects

static func is_bullet(object: Dictionary) -> bool:
    return "type" in object and object.type == "Bullet"

static func delete_on_collide(object: Dictionary) -> Dictionary:
    if is_bullet(object) and COLLISION.has_collision(object):
        object = object.duplicate()
        object["queue_free"] = true
    return object
