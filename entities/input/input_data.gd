class_name InputData
extends Reference

var horizontal = 0
var vertical = 0
var fire = false
var previous_state = false
var next_state = false
var history = {}

func keys():
    return ["horizontal", "vertical", "fire", "previous_state", "next_state"]

func record(tick):
    history[tick] = {}
    for key in keys():
        history[tick][key] = self[key]

func rewind(tick):
    if history.has(tick):
        for key in keys():
            self[key] = history[tick][key]

func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)
