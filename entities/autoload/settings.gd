extends Node

var ticks_per_second = 60 setget set_ticks_per_second
var tick_rate = 1.0 / 60 setget set_tick_rate

func set_ticks_per_second(value : float):
    ticks_per_second = value
    tick_rate = 1.0 / value if value != 0.0 else 0.0

func set_tick_rate(value : float):
    tick_rate = value
    ticks_per_second = 1 / value if value != 0.0 else 0.0
