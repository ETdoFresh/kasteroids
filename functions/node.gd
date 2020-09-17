extends Node

var to_dictionary = funcref(self, "_to_dictionary")
var update_sprite_scale = funcref(self, "_update_sprite_scale")
var has_node = funcref(self, "_has_node")
var queue_delete = funcref(self, "_queue_delete")
var is_queue_delete = funcref(self, "_is_queue_delete")

func _to_dictionary(child_node : Node) -> Dictionary:
    var object = {}
    if "type" in child_node: object["type"] = child_node.type
    if "id" in child_node: object["id"] = child_node.id
    if "global_position" in child_node: object["position"] = child_node.global_position
    if "global_rotation" in child_node: object["rotation"] = child_node.global_rotation
    if "sprite" in child_node:
        if "global_scale" in child_node: object["scale"] = child_node.sprite.global_scale
    else:
        if "global_scale" in child_node: object["scale"] = child_node.global_scale
    if "linear_velocity" in child_node: object["linear_velocity"] = child_node.linear_velocity
    if "angular_velocity" in child_node: object["angular_velocity"] = child_node.angular_velocity
    if "input" in child_node: object["input"] = child_node.input
    if "speed" in child_node: object["speed"] = child_node.speed
    if "spin" in child_node: object["spin"] = child_node.speed
    if "name" in child_node: object["name"] = child_node.name
    if "min_angular_velocity" in child_node: object["min_angular_velocity"] = child_node.min_angular_velocity
    if "max_angular_velocity" in child_node: object["max_angular_velocity"] = child_node.max_angular_velocity
    if "min_linear_velocity" in child_node: object["min_linear_velocity"] = child_node.min_linear_velocity
    if "max_linear_velocity" in child_node: object["max_linear_velocity"] = child_node.max_linear_velocity
    if "min_scale" in child_node: object["min_scale"] = child_node.min_scale
    if "max_scale" in child_node: object["max_scale"] = child_node.max_scale
    if "mass" in child_node: object["mass"] = child_node.mass
    if "bounce_coeff" in child_node: object["bounce_coeff"] = child_node.bounce_coeff
    if "randomize_angular_velocity" in child_node: object["randomize_angular_velocity"] = child_node.randomize_angular_velocity
    if "randomize_linear_velocity" in child_node: object["randomize_linear_velocity"] = child_node.randomize_linear_velocity
    if "randomize_scale" in child_node: object["randomize_scale"] = child_node.randomize_scale
    if "gun" in child_node: object["gun"] = child_node.gun
    if "cooldown" in child_node: object["cooldown"] = child_node.cooldown
    if "cooldown_timer" in child_node: object["cooldown_timer"] = child_node.cooldown_timer
    if child_node is Node2D: object["node"] = child_node
    return object

func _update_sprite_scale(_key, objects):
    for object in objects.values():
        if "node" in object and object.node and "sprite" in object.node:
            object.node.sprite.global_scale = object.scale
    return objects

func _has_node(object: Dictionary) -> Dictionary:
    return "node" in object and object.node

func _queue_delete(key: int, object: Dictionary) -> Dictionary:
    if not _is_queue_delete(key, object): return object
    if not _has_node(object): return object
    object = object.duplicate()
    object.node.queue_free()
    var _1 = object.erase("node")
    return object

func _is_queue_delete(_key, object: Dictionary) -> bool:
    return "queue_delete" in object and object.queue_delete
