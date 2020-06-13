extends Node

export var player_name = "Local Player"
export var horizontal = 0
export var vertical = 0
export var fire = false


var virtual_up = false
var virtual_down = false
var virtual_left = false
var virtual_right = false
var virtual_fire = false

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

func _input(event):
    vertical = 0
    if Input.is_action_pressed("player_up") || virtual_up:
        vertical -= 1
    if Input.is_action_pressed("player_down") || virtual_down:
        vertical += 1

    horizontal = 0
    if Input.is_action_pressed("player_left") || virtual_left:
        horizontal -= 1
    if Input.is_action_pressed("player_right") || virtual_right:
        horizontal += 1
        
    fire = Input.is_action_pressed("player_fire") || virtual_fire
