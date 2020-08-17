class_name KeyboardShortcuts
extends Node

onready var inputs = get_parent().get_node("Inputs")

func _input(event):
    if event is InputEventKey:
        if event.pressed:
            if Input.is_key_pressed(KEY_CONTROL):
                if event.scancode == KEY_R: # +Control
                    #warning-ignore:return_value_discarded
                    get_tree().paused = false
                    get_tree().change_scene_to(Scene.MENU)
                    return
                
                if event.scancode == KEY_1: # +Control
                    if get_parent().get_parent().has_node("Server/World"):
                        get_parent().get_parent().get_node("Server/World").visible = \
                            not get_parent().get_parent().get_node("Server/World").visible
                        return
                
                if event.scancode == KEY_2: # +Control
                    if get_parent().has_node("LatestReceivedWorld"):
                        get_parent().get_node("LatestReceivedWorld").visible = \
                            not get_parent().get_node("LatestReceivedWorld").visible
                        return
                
                if event.scancode == KEY_3: # +Control
                    if get_parent().has_node("InterpolatedWorld"):
                        get_parent().get_node("InterpolatedWorld").visible = \
                            not get_parent().get_node("InterpolatedWorld").visible
                        return
                
                if event.scancode == KEY_4: # +Control
                    if get_parent().has_node("ExtrapolatedWorld"):
                        get_parent().get_node("ExtrapolatedWorld").visible = \
                            not get_parent().get_node("ExtrapolatedWorld").visible
                        return
                
                if event.scancode == KEY_5: # +Control
                    if get_parent().has_node("PredictedWorld"):
                        get_parent().get_node("PredictedWorld").visible = \
                            not get_parent().get_node("PredictedWorld").visible
                        return
                
                if event.scancode == KEY_6: # +Control
                    if get_parent().has_node("PresentationWorld"):
                        get_parent().get_node("PresentationWorld").visible = \
                            not get_parent().get_node("PresentationWorld").visible
                        return
                
                if event.scancode == KEY_P: # +Control
                    get_tree().paused = !get_tree().paused
                
                if event.scancode == KEY_N: # +Control
                    get_tree().paused = false
                    yield(get_tree(),"physics_frame")
                    yield(get_tree(),"physics_frame")
                    get_tree().paused = true
            
            if event.scancode == KEY_F11:
                OS.window_fullscreen = !OS.window_fullscreen
            
            if event.scancode == KEY_DELETE:
                if inputs.get_child_count() > 0:
                    inputs.get_child(0).queue_free()
            
            if event.scancode == KEY_INSERT:
                get_parent().get_node("Inputs").create(Scene.KEYBOARD_PLUS_GUI)
