class_name NodeFunctions

static func to_object(child_node : Node) -> Dictionary:
    var object = {}
    if "type" in child_node: object["type"] = child_node.type
    if "global_position" in child_node: object["position"] = child_node.global_position
    if "global_rotation" in child_node: object["rotation"] = child_node.global_rotation
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
    if child_node is Sprite: object["sprite"] = child_node
    return object

static func update_display(object : Dictionary) -> Dictionary:
    if not "sprite" in object: return object
    var sprite = object.sprite
    if "global_position" in sprite: sprite.global_position = object.position
    if "global_rotation" in sprite: sprite.global_rotation = object.rotation
    if "global_scale" in sprite: sprite.global_scale = object.scale
    return object
