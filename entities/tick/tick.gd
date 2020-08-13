extends Node

signal tick

var precise_tick = 0
var previous_tick = 0
var tick = 0
var time = 0

func _physics_process(delta):
    precise_tick += delta * Settings.ticks_per_second
    tick = int(round(precise_tick))
    time += delta
    
    for _i in range(previous_tick, tick):
        emit_signal("tick")
    
    previous_tick = tick
