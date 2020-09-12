class_name CollisionFunctions

static func has_collision(object: Dictionary) -> bool:
    return "collision" in object and object.collision != null

static func get_collision(object: Dictionary):
    return object.collision
