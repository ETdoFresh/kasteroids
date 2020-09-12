class_name PhysicsNodesFunctions

static func setup_physical_bodies(object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    var kinematic_body : KinematicBody2D = object.node
    kinematic_body.global_position = object.position
    kinematic_body.global_rotation = object.rotation
    kinematic_body.get_node("CollisionShape2D").scale = object.scale
    return object

static func update_objects_from_physical_bodies(object: Dictionary) -> Dictionary:
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
