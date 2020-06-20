extends Node

const KeyboardPlusGUIScene = preload("res://entities/input/keyboard_plus_gui.tscn")

onready var inputs = get_parent().get_node("Inputs")

func _input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_R:
           get_tree().change_scene("res://scenes/menu.tscn")
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_F11:
            OS.window_fullscreen = !OS.window_fullscreen
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_DELETE:
            if inputs.get_child_count() > 0:
                inputs.get_child(0).queue_free()
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_INSERT:
            var new_input = get_parent().get_node("Inputs").create(KeyboardPlusGUIScene)
