extends Node

func to_dictionary(obj):
    return {
        "id": obj.id,
        "type": "Asteroid",
        "position": obj.global_position,
        "rotation": obj.global_rotation,
        "scale": obj.collision_shape_2d.scale,
        "linear_velocity": obj.linear_velocity,
        "angular_velocity": obj.angular_velocity }

func from_dictionary(obj, dictionary):
    if dictionary.has("id"): obj.id = dictionary.id
    if dictionary.has("position"): obj.global_position = dictionary.position
    if dictionary.has("rotation"): obj.global_rotation = dictionary.rotation
    if dictionary.has("scale"): obj.collision_shape_2d.scale = dictionary.scale
    if dictionary.has("linear_velocity"): obj.linear_velocity = dictionary.linear_velocity
    if dictionary.has("angular_velocity"): obj.angular_velocity = dictionary.angular_velocity
