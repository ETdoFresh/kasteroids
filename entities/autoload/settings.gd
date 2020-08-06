extends Node

var interpolation_enable = false

func _process(_delta):
    if Input.is_action_just_pressed("interpolation_toggle"):
        interpolation_enable = not interpolation_enable
