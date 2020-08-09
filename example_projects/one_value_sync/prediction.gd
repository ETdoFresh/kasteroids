extends Node

var t = 0
var future_tick = 0
var history = {}
var misses = 0
var speed = 0.01

onready var server_tick = get_parent().get_node("ServerTick")

func recieve_and_correct_past(tick, recieved_t):
    if history.size() > 0 && history.keys()[0] > tick:
            return
    
    var missing_tick = not history.has(tick)
    var mismatched_value = not float_equal(history[tick], recieved_t) if history.has(tick) else false
    
    if missing_tick || mismatched_value:
        misses += 1
        history.clear()
        history[tick] = recieved_t
        t = recieved_t
        future_tick = tick
        var smooth_tick = int(ceil(server_tick.smooth_tick))
        for current_tick in range(tick + 1, smooth_tick + 1):
            simulate()
            if current_tick == smooth_tick:
                t = history[current_tick]
    else:
        for i in range(history.size() - 1, -1, -1):
            if history.keys()[i] < tick:
                history.erase(history.keys()[i])
    return

func simulate():
    future_tick += 1
    t += speed * Settings.tick_rate
    history[int(future_tick)] = t
    return t

func simulate_from_past(previous_value):
    var current_value = previous_value + speed * Settings.tick_rate
    return current_value

func float_equal(a, b):
    return abs(a - b) < 0.000001
