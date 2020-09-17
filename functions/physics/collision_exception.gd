class_name CollisionExceptionFunctions

const LIST = ListFunctions

static func has_collision_exception(object: Dictionary, id: int) -> bool:
    return "collision_exceptions" in object and object.collision_exceptions.has(id)

static func add_collision_exception(object: Dictionary, other_object_id: int) -> Dictionary:
    object = object.duplicate()
    if not "collision_exceptions" in object:
        object["collision_exceptions"] = []
    object.collision_exceptions = LIST.append(object.collision_exceptions, other_object_id)
    return object
