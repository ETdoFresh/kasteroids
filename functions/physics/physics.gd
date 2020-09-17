class_name PhysicsFunctions

static func update_physical_body(_key: int, object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    if not object.node: return object
    object.node.global_position = object.position
    object.node.global_rotation = object.rotation
    object.node.get_node("CollisionShape2D").scale = object.scale
    return object

static func move(_key: int, object : Dictionary, delta : float) -> Dictionary:
    if not is_physical(object): return object
    object = object.duplicate()
    object.position += object.linear_velocity * delta
    object.rotation += object.angular_velocity * delta
    return object

static func is_physical(object: Dictionary):
    return ("linear_velocity" in object
        and "angular_velocity" in object
        and "position" in object
        and "rotation" in object)
