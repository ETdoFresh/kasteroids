extends Node

export var player_name = "TCP Player"
export var horizontal = 0
export var vertical = 0
export var fire = false

var virtual_up = false
var virtual_down = false
var virtual_left = false
var virtual_right = false
var virtual_fire = false
var previous_state = false
var next_state = false

func _ready():
    var v = get_node("../Virtual Controls")
    v.connect("down_pressed", self, "_on_Virtual_Controls_down_pressed")
    v.connect("down_released", self, "_on_Virtual_Controls_down_released")
    v.connect("fire_pressed", self, "_on_Virtual_Controls_fire_pressed")
    v.connect("fire_released", self, "_on_Virtual_Controls_fire_released")
    v.connect("left_pressed", self, "_on_Virtual_Controls_left_pressed")
    v.connect("left_released", self, "_on_Virtual_Controls_left_released")
    v.connect("right_pressed", self, "_on_Virtual_Controls_right_pressed")
    v.connect("right_released", self, "_on_Virtual_Controls_right_released")
    v.connect("up_pressed", self, "_on_Virtual_Controls_up_pressed")
    v.connect("up_released", self, "_on_Virtual_Controls_up_released")
    v.connect("previous_state_pressed", self, "on_previous_state_pressed")
    v.connect("next_state_pressed", self, "on_next_state_pressed")

func _on_Virtual_Controls_down_pressed():	virtual_down = true
func _on_Virtual_Controls_down_released():	virtual_down = false
func _on_Virtual_Controls_fire_pressed():	virtual_fire = true
func _on_Virtual_Controls_fire_released():	virtual_fire = false
func _on_Virtual_Controls_left_pressed():	virtual_left = true
func _on_Virtual_Controls_left_released():	virtual_left = false
func _on_Virtual_Controls_right_pressed():	virtual_right = true
func _on_Virtual_Controls_right_released():	virtual_right = false
func _on_Virtual_Controls_up_pressed():	virtual_up = true
func _on_Virtual_Controls_up_released():	virtual_up = false
func on_previous_state_pressed(): previous_state = true
func on_next_state_pressed(): next_state = true

func _process(_delta):
    vertical = 0
    if virtual_up:
        vertical -= 1
    if virtual_down:
        vertical += 1

    horizontal = 0
    if virtual_left:
        horizontal -= 1
    if virtual_right:
        horizontal += 1
        
    fire = virtual_fire
    
    if previous_state:
        previous_state = false
        
    if next_state:
        next_state = false

func _unhandled_input(event):
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire", "player_previous_state", "player_next_state"]
    var variable = ["virtual_up","virtual_down","virtual_left","virtual_right","virtual_fire", "previous_state", "next_state"]
    
    for i in range(actions.size()):
        if event.is_action_pressed(actions[i]):
            self[variable[i]] = true
        elif event.is_action_released(actions[i]):
            self[variable[i]] = false
