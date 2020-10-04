extends Node

var history = {}

func record(tick, dictionary):
    history[tick] = dictionary

func rewind(tick):
    if history.has(tick):
        return history[tick]
    else:
        return null

func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)

func has(tick):
    return history.has(tick)
