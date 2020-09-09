extends Node

var dictionary = preload("res://dictionary.gd")

static func move(object : Dictionary, delta : float) -> Dictionary:
    if not "position" in object: return object
    if not "linear_velocity" in object: return object
    object = object.duplicate()
    object.position += object.linear_velocity * delta
    return object
