class_name PhysicsNodesFunctions

static func update_physical_body(object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    var kinematic_body : KinematicBody2D = object.node
    kinematic_body.global_position = object.position
    kinematic_body.global_rotation = object.rotation
    kinematic_body.get_node("CollisionShape2D").scale = object.scale
    return object

static func move(object : Dictionary, delta : float) -> Dictionary:
    if not "linear_velocity" in object: return object
    if not "angular_velocity" in object: return object
    if not "position" in object: return object
    if not "rotation" in object: return object
    object = object.duplicate()
    object.position += object.linear_velocity * delta
    object.rotation += object.angular_velocity * delta
    return object

static func collide(object : Dictionary, other_objects : Array) -> Dictionary:
    if not "node" in object: return object
    if not "collision_shapes_2d" in object.node: return object
    object = object.duplicate()
    for collision_shape_2d in object.node.collision_shapes_2d:
        var shape = collision_shape_2d.shape
        var transform = collision_shape_2d.global_transform
        for other_object in other_objects:
            if not "node" in other_object: continue
            if not "collision_shapes_2d" in other_object.node: return other_object
            if object.node == other_object.node: continue
            for other_collision_shape_2d in other_object.node.collision_shapes_2d:
                var other_shape = other_collision_shape_2d.shape
                var other_transform = other_collision_shape_2d.global_transform
                if did_collide(shape, transform, other_shape, other_transform):
                    object["collisions"].append(get_collision_data(other_object,
                        shape, transform, other_shape, other_transform))
                    break # Only consider one collision per pair of objects
    return object

static func did_collide(shape, transform, other_shape, other_transform):
    return shape.collide(transform, other_shape, other_transform)

static func get_collision_data(other_object, shape, transform, other_shape, other_transform):
    var contacts = shape.collide_and_get_contacts(transform, other_shape, other_transform)
    var average_contact = Vector2.ZERO
    for contact in contacts: average_contact += contact
    average_contact /= contacts.size()
    var to_contact = average_contact - other_transform.get_origin()
    var penetration = 0
    if other_shape is CircleShape2D:
        penetration = other_shape.radius * other_object.scale.x - to_contact.length()
    penetration = max(penetration, 0)
    var normal = to_contact.normalized()
    return {
        "other_mass": other_object.mass,
        "other_linear_velocity": other_object.linear_velocity,
        "position": average_contact,
        "normal": normal,
        "penetration": penetration}
