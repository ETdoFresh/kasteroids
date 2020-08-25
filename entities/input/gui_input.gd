extends Control

var up = false
var down = false
var left = false
var right = false
var fire = false

func _ready():
    var _01 = $LeftControls/Up.connect("touch_button_down", self, "up_pressed")
    var _02 = $LeftControls/Up.connect("touch_button_up", self, "up_released")
    var _03 = $LeftControls/Down.connect("touch_button_down", self, "down_pressed")
    var _04 = $LeftControls/Down.connect("touch_button_up", self, "down_released")
    var _05 = $LeftControls/Left.connect("touch_button_down", self, "left_pressed")
    var _06 = $LeftControls/Left.connect("touch_button_up", self, "left_released")
    var _07 = $LeftControls/Right.connect("touch_button_down", self, "right_pressed")
    var _08 = $LeftControls/Right.connect("touch_button_up", self, "right_released")
    var _09 = $RightControls/Fire.connect("touch_button_down", self, "fire_pressed")
    var _10 = $RightControls/Fire.connect("touch_button_up", self, "fire_released")

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
