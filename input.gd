extends Node

static func apply(object : Dictionary) -> Dictionary:
    if not "input" in object: return object
    if not "linear_velocity" in object: return object
    object = object.duplicate()
    object.linear_velocity = Vector2(object.input.horizontal, object.input.vertical)
    return object
