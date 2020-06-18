extends Control

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
    $LeftControls/Up.connect("button_down", self, "up_pressed")
    $LeftControls/Up.connect("button_up", self, "up_released")
    $LeftControls/Down.connect("button_down", self, "down_pressed")
    $LeftControls/Down.connect("button_up", self, "down_released")
    $LeftControls/Left.connect("button_down", self, "left_pressed")
    $LeftControls/Left.connect("button_up", self, "left_released")
    $LeftControls/Right.connect("button_down", self, "right_pressed")
    $LeftControls/Right.connect("button_up", self, "right_released")
    $RightControls/Fire.connect("button_down", self, "fire_pressed")
    $RightControls/Fire.connect("button_up", self, "fire_released")
    $RightControls2/NextState.connect("button_down", self, "next_state")
    $RightControls2/PreviousState.connect("button_down", self, "previous_state")

func up_pressed(): up = true
func up_released(): up = false
func down_pressed(): down = true
func down_released(): down = false
func left_pressed(): left = true
func left_released(): left = false
func right_pressed(): right = true
func right_released(): right = false
func fire_pressed(): fire = true
func fire_released(): fire = false

func next_state():
    next_state = true
    was_next_state = false
    
func previous_state():
    previous_state = true
    was_previous_state = false

func _process(delta):
    next_state = false
    previous_state = false
