class_name KeyboardPlusGUI
extends Node

var tick = 0
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
var username = "WASD Keyboard Plus GUI"

onready var repeater = $Repeater

func _process(_delta):
    vertical = 0
    if up || $GUIInput.up: vertical -= 1
    if down || $GUIInput.down: vertical += 1
    
    horizontal = 0
    if left || $GUIInput.left: horizontal -= 1
    if right || $GUIInput.right: horizontal += 1
    
    fire = fire_button || $GUIInput.fire
    
    next_state = Input.is_action_just_pressed("player_next_state") || $GUIInput.next_state
    previous_state = Input.is_action_just_pressed("player_previous_state") || $GUIInput.previous_state

func _unhandled_input(event):
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire"]
    var variable = ["up","down","left","right","fire_button"]
    
    for i in range(actions.size()):
        if event.is_action_pressed(actions[i]):
            self[variable[i]] = true
        elif event.is_action_released(actions[i]):
            self[variable[i]] = false

func serialize():
    var serialized = {
        "username": username, 
        "tick": tick, 
        "horizontal": horizontal, 
        "vertical": vertical, 
        "fire": fire }
    if repeater:
        return repeater.add(serialized)
    else:
        return to_json([serialized])
