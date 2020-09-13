class_name PhysicsNodesFunctions

static func setup_physical_body(object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    var kinematic_body : KinematicBody2D = object.node
    kinematic_body.global_position = object.position
    kinematic_body.global_rotation = object.rotation
    kinematic_body.get_node("CollisionShape2D").scale = object.scale
    return object

static func update_object_from_physical_body(object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    var kinematic_body : KinematicBody2D = object.node
    object = object.duplicate()
    object.position = kinematic_body.global_position
    object.rotation = kinematic_body.global_rotation
    return object

static func move_and_collide(object : Dictionary, delta : float) -> Dictionary:
    if not "node" in object: return object
    var kinematic_body : KinematicBody2D = object.node
    object = object.duplicate()
    kinematic_body.rotate(object.angular_velocity * delta)
    object["collision"] = kinematic_body.move_and_collide(object.linear_velocity * delta)
    return object

static func replace_collision_with_dictionary(object: Dictionary, other_objects: Array) -> Dictionary:
    if not "collision" in object: return object
    if not object.collision: return object
    for other_object in other_objects:
        if not "node" in other_object: continue
        if object.collision.collider == other_object.node:
            object = object.duplicate()
            object.collision = {
                "other": other_object, 
                "position": object.collision.position,
                "normal": object.collision.normal,
                "remainder": object.collision.remainder}
            return object
    return object

static func add_collision_to_other_collider(object: Dictionary, other_objects: Array) -> Dictionary:
    if "collision" in object and object.collision: return object
    for other_object in other_objects:
        if not "collision" in other_object: continue
        if not other_object.collision: continue
        if not "other" in other_object.collision: continue
        if other_object.collision.other == object:
            object = object.duplicate()
            object["collision"] = {
                "other": other_object,
                "position": other_object.collision.position,
                "normal": -other_object.collision.normal,
                "remainder": Vector2.ZERO,
                "is_other": true}
            return object
    return object
