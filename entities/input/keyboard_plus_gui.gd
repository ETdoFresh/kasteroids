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
var username = "WASD Keyboard Plus GUI"
var history = {}

onready var repeater = $Repeater

func _process(_delta):
    vertical = 0
    if up || $GUIInput.up: vertical -= 1
    if down || $GUIInput.down: vertical += 1
    
    horizontal = 0
    if left || $GUIInput.left: horizontal -= 1
    if right || $GUIInput.right: horizontal += 1
    
    fire = fire_button || $GUIInput.fire

func _unhandled_input(event):
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire"]
    var variable = ["up","down","left","right","fire_button"]
    
    for i in range(actions.size()):
        if event.is_action_pressed(actions[i]):
            self[variable[i]] = true
        elif event.is_action_released(actions[i]):
            self[variable[i]] = false

func to_list():
    var item = {
        "username": username, 
        "tick": tick, 
        "horizontal": horizontal, 
        "vertical": vertical, 
        "fire": fire }
    if repeater:
        return repeater.add(item)
    else:
        return [item]

func to_dictionary():
    return {"type": "input", "list": to_list()}

# warning-ignore:shadowed_variable
func record(tick):
    history[tick] = {}
    for key in ["horizontal", "vertical", "fire"]:
        history[tick][key] = self[key]

# warning-ignore:shadowed_variable
func rewind(tick):
    if history.has(tick):
        for key in ["horizontal", "vertical", "fire"]:
            self[key] = history[tick][key]

# warning-ignore:shadowed_variable
func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)
