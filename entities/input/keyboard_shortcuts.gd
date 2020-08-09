class_name KeyboardShortcuts
extends Node

onready var inputs = get_parent().get_node("Inputs")

func _input(event):
    if event is InputEventKey:
        if event.pressed:
            if Input.is_key_pressed(KEY_CONTROL):
                if event.scancode == KEY_R:
                    #warning-ignore:return_value_discarded
                    get_tree().paused = false
                    get_tree().change_scene_to(Scene.MENU)
            
            if event.scancode == KEY_F11:
                OS.window_fullscreen = !OS.window_fullscreen
        
            if Input.is_key_pressed(KEY_CONTROL):
                if event.scancode == KEY_P:
                    get_tree().paused = !get_tree().paused
            
            if Input.is_key_pressed(KEY_CONTROL):
                if event.scancode == KEY_N:
                    get_tree().paused = false
                    yield(get_tree(),"physics_frame")
                    yield(get_tree(),"physics_frame")
                    get_tree().paused = true
        
            if event.scancode == KEY_DELETE:
                if inputs.get_child_count() > 0:
                    inputs.get_child(0).queue_free()
        
            if event.scancode == KEY_INSERT:
                get_parent().get_node("Inputs").create(Scene.KEYBOARD_PLUS_GUI)
