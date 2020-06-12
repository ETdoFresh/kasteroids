extends Node

class_name RestartSceneWithR

func _input(event):
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_R:
            get_tree().reload_current_scene()
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_F11:
            OS.window_fullscreen = !OS.window_fullscreen
