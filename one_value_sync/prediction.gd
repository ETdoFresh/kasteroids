extends Node

var t = 0
var future_tick = 0
var history = {}
var misses = 0
var speed = 0.01
var tick_rate = 1.0 / Engine.iterations_per_second

func recieve_and_correct_past(tick, recieved_t):
    tick = int(tick)
    if not history.has(tick):
        return
    
    if not float_equal(history[tick], recieved_t):
        misses += 1
        var _delta = recieved_t - history[tick]
        history[tick] = recieved_t
        for current_tick in range(tick + 1, future_tick + 1):
            var previous_tick = current_tick - 1
            history[current_tick] = simulate(history[previous_tick])
            if current_tick == future_tick:
                t = history[current_tick]

func simulate(state = null):
    if state == null:
        future_tick = get_parent().get_node("ServerTick").smooth_tick
        t += speed * tick_rate
        history[int(future_tick)] = t
        return t
    else:
        var next_state = state + speed * tick_rate
        return next_state

func float_equal(a, b):
    return abs(a - b) < 0.000001
