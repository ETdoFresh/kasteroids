class_name KeyboardShortcuts
extends Node

onready var inputs = get_parent().get_node("Inputs")

func _ready():
    if has_node("../UI/Button"):
        #warning-ignore:return_value_discarded
        get_node("../UI/Button").connect("button_down", self, "menu_gui_press")

func _input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_R:
            #warning-ignore:return_value_discarded
           get_tree().change_scene_to(Scene.MENU)
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_F11:
            OS.window_fullscreen = !OS.window_fullscreen
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_DELETE:
            if inputs.get_child_count() > 0:
                inputs.get_child(0).queue_free()
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_INSERT:
            get_parent().get_node("Inputs").create(Scene.KEYBOARD_PLUS_GUI)

func menu_gui_press():
    #warning-ignore:return_value_discarded
    get_tree().change_scene(Scene.MENU)
