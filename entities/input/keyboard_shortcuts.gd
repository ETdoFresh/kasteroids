class_name KeyboardShortcuts
extends Node

onready var inputs = get_parent().get_node("Inputs")

func _ready():
    if has_node("../UI/Button"):
        #warning-ignore:return_value_discarded
        get_node("../UI/Button").connect("button_down", self, "menu_gui_press")

func _input(event):
    if event is InputEventKey:
        if event.pressed:
            if event.scancode == KEY_R:
                #warning-ignore:return_value_discarded
                get_tree().change_scene_to(Scene.MENU)
            
            if event.scancode == KEY_F11:
                OS.window_fullscreen = !OS.window_fullscreen
        
            if event.scancode == KEY_P:
                get_tree().paused = !get_tree().paused
            
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

func menu_gui_press():
    #warning-ignore:return_value_discarded
    get_tree().change_scene_to(Scene.MENU)
