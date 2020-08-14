class_name InputData
extends Reference

export var input_name = "Local Player"

var horizontal = 0
var vertical = 0
var fire = false
var previous_state = false
var next_state = false

func keys():
    return ["horizontal", "vertical", "fire", "previous_state", "next_state"]
