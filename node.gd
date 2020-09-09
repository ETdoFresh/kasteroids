extends Node

static func to_object(child_node : Node) -> Dictionary:
    var object = {}
    if "type" in child_node: object["type"] = child_node.type
    if "global_position" in child_node: object["position"] = child_node.global_position
    if "global_rotation" in child_node: object["rotation"] = child_node.global_rotation
    if "global_scale" in child_node: object["scale"] = child_node.global_scale
    if "linear_velocity" in child_node: object["linear_velocity"] = child_node.linear_velocity
    if "angular_velocity" in child_node: object["angular_velocity"] = child_node.angular_velocity
    if child_node is Sprite: object["sprite"] = child_node
    return object

static func from_object(object : Dictionary) -> Dictionary:
    if not "sprite" in object: return object
    var sprite = object.sprite
    if "global_position" in sprite: sprite.global_position = object.position
    if "global_rotation" in sprite: sprite.global_rotation = object.rotation
    if "global_scale" in sprite: sprite.global_scale = object.scale
    if "linear_velocity" in sprite: sprite.linear_velocity = object.linear_velocity
    if "angular_velocity" in sprite: sprite.angular_velocity = object.angular_velocity
    return object
