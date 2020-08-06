extends Node

signal connected(input)
signal disconnected(input)

var connected = false

var up = false
var down = false
var left = false
var right = false
var fire = false

var horizontal = 0
var vertical = 0

var next_state = false
var previous_state = false


func _unhandled_input(event):
    if event.is_action_pressed("player1_start"):
        connected = not connected
        if connected: emit_signal("connected", self)
        else: emit_signal("disconnected", self)
    
    previous_state = event.is_action_pressed("player_previous_state")
    next_state = event.is_action_pressed("player_next_state")
    
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire"]
    var variables = ["up","down","left","right","fire"]
    for i in range(actions.size()):
        if event.is_action_pressed(actions[i]):
            self[variables[i]] = true
        elif event.is_action_released(actions[i]):
            self[variables[i]] = false
    
    vertical = 0
    if up: vertical -= 1
    if down: vertical += 1
    
    horizontal = 0
    if left: horizontal -= 1
    if right: horizontal += 1
