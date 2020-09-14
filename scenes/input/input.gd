extends Node

var horizontal = 0
var vertical = 0
var fire = false

func _process(_delta):
    var left = Input.get_action_strength("player_left")
    var right = Input.get_action_strength("player_right")
    var up = Input.get_action_strength("player_up")
    var down = Input.get_action_strength("player_down")
    fire = Input.is_action_pressed("player_fire")
    horizontal = right - left
    vertical = down - up
