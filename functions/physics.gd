class_name PhysicsFunctions

static func move(object : Dictionary, delta : float) -> Dictionary:
    if not "linear_velocity" in object: return object
    if not "angular_velocity" in object: return object
    object = object.duplicate()
    object.position += object.linear_velocity * delta
    object.rotation += object.angular_velocity * delta
    return object
