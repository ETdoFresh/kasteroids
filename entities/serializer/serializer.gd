extends Node

func to_dictionary(obj, type_name):
    var dictionary = {}
    dictionary["type"] = type_name
    if "id" in obj: dictionary["id"] = obj.id
    if "global_position" in obj: dictionary["position"] = obj.global_position
    if "global_rotation" in obj: dictionary["rotation"] = obj.global_rotation
    if "collision_shape_2d" in obj: dictionary["scale"] = obj.collision_shape_2d.scale
    if "physics" in obj: dictionary["linear_velocity"] = obj.physics.linear_velocity
    if "physics" in obj: dictionary["angular_velocity"] = obj.physics.angular_velocity
    if "ship_id" in obj: dictionary["ship_id"] = obj.ship_id
    if "username" in obj: dictionary["username"] = obj.username
    if "create_position" in obj: dictionary["create_position"] = obj.create_position
    return dictionary

func from_dictionary(obj, dictionary):
    if not dictionary: return
    if dictionary.has("id"): obj.id = dictionary.id
    if dictionary.has("position"): obj.global_position = dictionary.position
    if dictionary.has("rotation"): obj.global_rotation = dictionary.rotation
    if dictionary.has("scale"): obj.collision_shape_2d.scale = dictionary.scale
    if dictionary.has("linear_velocity"): obj.physics.linear_velocity = dictionary.linear_velocity
    if dictionary.has("angular_velocity"): obj.physics.angular_velocity = dictionary.angular_velocity
    if dictionary.has("ship_id"): obj.ship_id = dictionary.ship_id
    if dictionary.has("username"): obj.username = dictionary.username
    if dictionary.has("create_position"): obj.create_position = dictionary.create_position
