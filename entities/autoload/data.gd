extends Node

const INPUT_VARIABLES = ["horizontal", "vertical", "fire", "next_state", "previous_state"]

const NULL_INPUT = {
    "horizontal": 0, 
    "vertical": 0, 
    "fire": false, 
    "next_state": false, 
    "previous_state": false
}

func copy_values(keys, source, destination):
    for key in keys:
        if key in source && key in destination:
            destination[key] = source[key]

func get_physics_layer_id_by_name(layer_name):
    for i in range(1, 21):
        var settings_layer_name = ProjectSettings.get_setting(
            str("layer_names/2d_physics/layer_", i))
        if layer_name == settings_layer_name:
            return i
    return 0
