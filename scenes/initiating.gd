extends Node2D

onready var original_position = global_position
onready var original_rotation = global_rotation

func state_enter(_previous_state):
    global_position = original_position
    global_rotation = original_rotation

    $LabelNode2D.global_rotation = 0
