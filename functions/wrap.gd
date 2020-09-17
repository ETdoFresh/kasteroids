extends Node

var simulate = funcref(self, "_simulate")
var wrap = funcref(self, "_wrap")

func _simulate(_key, objects):
    return map(objects, wrap)

static func _wrap(_key: int, object : Dictionary) -> Dictionary:
    if not "position" in object: return object
    object = object.duplicate()
    while(object.position.x < 0): object.position.x += 1920
    while(object.position.x >= 1920): object.position.x -= 1920
    while(object.position.y < 0): object.position.y += 1080
    while(object.position.y >= 1080): object.position.y -= 1080
    return object

static func map(dict, func_ref, arg = null): return DictionaryFunctions.map(dict, func_ref, arg)
