extends Node

var interpolated_tick = 0
var history = []

func add(tick, t):
    if history.size() > 0:
        if tick < history[0][0]:
            return
    history.insert(0, [tick, t])
