extends Node

func to_dictionary(obj, type_name):
    return {
        "id": obj.id,
        "type": type_name,
        "position": obj.global_position,
        "rotation": obj.global_rotation,
        "scale": obj.collision_shape_2d.scale,
        "linear_velocity": obj.physics.linear_velocity,
        "angular_velocity": obj.physics.angular_velocity }

func from_dictionary(obj, dictionary):
    if not dictionary: return
    if dictionary.has("id"): obj.id = dictionary.id
    if dictionary.has("position"): obj.global_position = dictionary.position
    if dictionary.has("rotation"): obj.global_rotation = dictionary.rotation
    if dictionary.has("scale"): obj.collision_shape_2d.scale = dictionary.scale
    if dictionary.has("linear_velocity"): obj.physics.linear_velocity = dictionary.linear_velocity
    if dictionary.has("angular_velocity"): obj.physics.angular_velocity = dictionary.angular_velocity
