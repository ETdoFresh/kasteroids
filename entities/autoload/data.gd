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
