extends Node

onready var world = get_parent()
onready var slider = $HSlider

func _ready():
    slider.connect("value_changed", self, "set_tick")
    slider.connect("gui_input", self, "pause_on_slider_click")
    world.connect("tick", self, "set_max_tick")

func _input(event):
    if event is InputEventKey and event.is_pressed() and not event.is_echo():
        if event.scancode == KEY_R:
            slider.max_value = 1
            world.set_to_tick(0)
            slider.value = world.tick
        if event.scancode == KEY_P:
            get_tree().paused = !get_tree().paused
        if event.scancode == KEY_PERIOD:
            get_tree().paused = true
            world.next_tick()
        if event.scancode == KEY_COMMA:
            get_tree().paused = true
            world.previous_tick()

func set_tick(tick):
    world.set_to_tick(int(tick))
    slider.value = world.tick

func set_max_tick():
    slider.max_value = world.tick
    slider.value = world.tick

func pause_on_slider_click(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            get_tree().paused = true
