class_name WrapFunctions

static func wrap(_key: int, object : Dictionary) -> Dictionary:
    if not "position" in object: return object
    object = object.duplicate()
    while(object.position.x < 0): object.position.x += 1920
    while(object.position.x >= 1920): object.position.x -= 1920
    while(object.position.y < 0): object.position.y += 1080
    while(object.position.y >= 1080): object.position.y -= 1080
    return object
