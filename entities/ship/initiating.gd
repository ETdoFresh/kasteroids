extends Node2D

onready var screen_size = get_viewport().get_visible_rect().size 
onready var starting_position = screen_size / 2
onready var starting_rotation = 0

func state_enter(_previous_state):
    global_position = starting_position
    global_rotation = starting_rotation

    $LabelNode2D.global_rotation = 0
