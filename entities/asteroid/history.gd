extends Node

var history = {}

func record(tick, dictionary):
    history[tick] = dictionary

func rewind(tick, obj):
    if history.has(tick):
        obj.from_dictionary(history[tick])

func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)

func has(tick):
    return history.has(tick)
