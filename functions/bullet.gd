class_name BulletFunctions

const NODE = NodeFunctions
const SHIP = ShipFunctions

static func shoot_bullets(objects: Array, world: Node) -> Array:
    var new_objects = objects.duplicate()
    for ship in objects:
        if not SHIP.is_ship(ship): continue
        if ship.input.fire:
            var new_bullet = SceneMap.get_scene("Bullet").instance()
            world.add_child(new_bullet)
            new_bullet.position = ship.gun.global_position
            new_bullet.rotation = ship.gun.global_rotation
            new_bullet.linear_velocity = Vector2(0, -800).rotated(ship.gun.global_rotation)
            new_objects.append(NODE.to_dictionary(new_bullet))
    return new_objects
