extends Node

onready var root = get_tree().get_root()
onready var gui_input = $GUIInput

var horizontal = 0
var vertical = 0
var fire = false

var up = false
var down = false
var left = false
var right = false
var fire_button = false
var next_state = false
var previous_state = false

func _process(_delta):
    vertical = 0
    if up || gui_input.up: vertical -= 1
    if down || gui_input.down: vertical += 1

    horizontal = 0
    if left || gui_input.left: horizontal -= 1
    if right || gui_input.right: horizontal += 1
    
    fire = fire_button || gui_input.fire
    
    next_state = Input.is_action_just_pressed("player_next_state") || gui_input.next_state
    previous_state = Input.is_action_just_pressed("player_previous_state") || gui_input.previous_state

func _unhandled_input(event):
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire"]
    var variable = ["up","down","left","right","fire_button"]
    
    for i in range(actions.size()):
        if event.is_action_pressed(actions[i]):
            self[variable[i]] = true
        elif event.is_action_released(actions[i]):
            self[variable[i]] = false

func _input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_R:
            #warning-ignore:return_value_discarded
            get_parent().queue_free()
            root.add_child(load("res://scenes/Main.tscn").instance())
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_F11:
            OS.window_fullscreen = !OS.window_fullscreen
