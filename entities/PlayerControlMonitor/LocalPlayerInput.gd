extends Node

onready var root = get_tree().get_root()
onready var world = $"../World"
onready var virtual_controls = $"Virtual Controls"

var up = false
var down = false
var left = false
var right = false
var fire = false
var next_state = false
var was_next_state = false
var previous_state = false
var was_previous_state = false

func _ready():
    virtual_controls.connect("down_pressed", self, "_on_Virtual_Controls_down_pressed")
    virtual_controls.connect("down_released", self, "_on_Virtual_Controls_down_released")
    virtual_controls.connect("fire_pressed", self, "_on_Virtual_Controls_fire_pressed")
    virtual_controls.connect("fire_released", self, "_on_Virtual_Controls_fire_released")
    virtual_controls.connect("left_pressed", self, "_on_Virtual_Controls_left_pressed")
    virtual_controls.connect("left_released", self, "_on_Virtual_Controls_left_released")
    virtual_controls.connect("right_pressed", self, "_on_Virtual_Controls_right_pressed")
    virtual_controls.connect("right_released", self, "_on_Virtual_Controls_right_released")
    virtual_controls.connect("up_pressed", self, "_on_Virtual_Controls_up_pressed")
    virtual_controls.connect("up_released", self, "_on_Virtual_Controls_up_released")
    virtual_controls.connect("previous_state_pressed", self, "on_previous_state_pressed")
    virtual_controls.connect("previous_state_released", self, "on_previous_state_released")
    virtual_controls.connect("next_state_pressed", self, "on_next_state_pressed")
    virtual_controls.connect("next_state_released", self, "on_next_state_released")

func _on_Virtual_Controls_down_pressed():   down = true
func _on_Virtual_Controls_down_released():  down = false
func _on_Virtual_Controls_fire_pressed():   fire = true
func _on_Virtual_Controls_fire_released():  fire = false
func _on_Virtual_Controls_left_pressed():   left = true
func _on_Virtual_Controls_left_released():  left = false
func _on_Virtual_Controls_right_pressed():  right = true
func _on_Virtual_Controls_right_released(): right = false
func _on_Virtual_Controls_up_pressed():     up = true
func _on_Virtual_Controls_up_released():    up = false
func on_previous_state_pressed():           previous_state = true
func on_previous_state_released():          previous_state = false
func on_next_state_pressed():               next_state = true
func on_next_state_released():              next_state = false

func _process(_delta):
    world.input.vertical = 0
    if up:
        world.input.vertical -= 1
    if down:
        world.input.vertical += 1

    world.input.horizontal = 0
    if left:
        world.input.horizontal -= 1
    if right:
        world.input.horizontal += 1
        
    world.input.fire = fire
    
    if previous_state:
        if not was_previous_state:
            world.input.previous_state = true
        else:
            world.input.previous_state = false
        was_previous_state = true
    else:
        world.input.previous_state = false
        was_previous_state = false
        
    if next_state:
        if not was_next_state:
            world.input.next_state = true
        else:
            world.input.next_state = false
        was_next_state = true
    else:
        world.input.next_state = false
        was_next_state = false
        

func _unhandled_input(event):
    var actions = ["player_up", "player_down", "player_left", "player_right", "player_fire", "player_previous_state", "player_next_state"]
    var variable = ["up","down","left","right","fire", "previous_state", "next_state"]
    
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
            root.add_child(load("res://scenes/Menu.tscn").instance())
    
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_F11:
            OS.window_fullscreen = !OS.window_fullscreen
