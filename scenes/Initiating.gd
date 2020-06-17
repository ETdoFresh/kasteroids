extends Node2DExtended

onready var original_position = base.position
onready var original_rotation = base.rotation

func state_enter(previous_state):
    base.position = original_position
    base.rotation = original_rotation
