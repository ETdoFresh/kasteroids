extends Node2D

func _ready():
    var overlay = load("res://DebugOverlay.tscn").instance()
    overlay.add_stat("FPS", Engine, "get_frames_per_second", true)
    overlay.add_stat("Player_State", $Ship/State, "active_state_name", false)
    overlay.add_stat("Player Position", $Ship, "position", false)
    overlay.add_stat("Player Rotation", $Ship, "rotation", false)
    overlay.add_stat("Player Scale", $Ship, "scale", false)
    add_child(overlay)
