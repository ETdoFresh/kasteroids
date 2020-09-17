extends Node

var simulate = funcref(self, "_simulate")
var update_physical_body = funcref(self, "_update_physical_body")
var move = funcref(self, "_move")
var is_physical = funcref(self, "_is_physical")

func _simulate(_key, objects: Dictionary, delta: float) -> Dictionary:
    objects = objects.duplicate()
    objects = map(objects, move, delta)
    objects = map(objects, update_physical_body) # Side-effect
    objects = map(objects, Collision.clear_collisions)
    objects = map(objects, BoundingBox.set_bounding_box)
    objects = reduce(objects, Collision.broad_phase, objects)
    objects = reduce(objects, Collision.narrow_phase, objects)
    objects = map(objects, Collision.fix_penetration)
    objects = map(objects, Collision.bounce_no_angular_velocity)
    return objects

static func _update_physical_body(_key: int, object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    if not object.node: return object
    object.node.global_position = object.position
    object.node.global_rotation = object.rotation
    object.node.get_node("CollisionShape2D").scale = object.scale
    return object

static func _move(_key: int, object : Dictionary, delta : float) -> Dictionary:
    if not _is_physical(object): return object
    object = object.duplicate()
    object.position += object.linear_velocity * delta
    object.rotation += object.angular_velocity * delta
    return object

static func _is_physical(object: Dictionary):
    return ("linear_velocity" in object
        and "angular_velocity" in object
        and "position" in object
        and "rotation" in object)

static func map(dict, func_ref, arg = null): return DictionaryFunctions.map(dict, func_ref, arg)
static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
static func reduce(dict, func_ref, acc): return DictionaryFunctions.reduce(dict, func_ref, acc)
