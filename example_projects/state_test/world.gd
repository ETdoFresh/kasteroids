extends Node2D

# This Node represents the Game World
# It is responsible for simulating all game_logic on children

signal tick

var tick = 0

onready var history = $History
onready var physics_space = get_world_2d().space
onready var fixed_delta = 1.0 / Settings.ticks_per_second

func _physics_process(_delta):
    simulate()

func simulate():
    tick += 1
    #physics_space.step()
    emit_signal("tick")

func set_to_tick(new_tick):
    tick = new_tick
    history.set_to_tick(tick)

func next_tick():
    if history.has_tick(tick + 1):
        tick += 1
        history.set_to_tick(tick)

func previous_tick():
    if history.has_tick(tick - 1):
        tick -= 1
        history.set_to_tick(tick)
