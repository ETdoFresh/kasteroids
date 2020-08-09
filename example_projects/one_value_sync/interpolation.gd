extends Node

var history = []

func add(tick, value):
    if history.size() > 0:
        if tick <= history[0].tick:
            return
    history.insert(0, {"tick": tick, "value": value})

func interpolate(current_tick, interpolation_rate):
    var interpolated_tick = interpolation_rate * Settings.simulation_iterations_per_second
    var target_tick = current_tick - interpolated_tick
    var before = get_before(target_tick)
    var after = get_after(target_tick)
    
    if before != null:
        for i in range(history.size() - 1, -1, -1):
            if history[i].tick < before.tick:
                history.remove(i)
    
    if before == null and after == null: return null
    if before != null and after == null: return before.value
    if before == null and after != null: return after.value
    if before.tick == after.tick: return before.value
    var t = target_tick - before.tick
    t /= after.tick - before.tick
    return lerp(before.value, after.value, t)

func get_before(tick):
    if history.size() == 0: return null
    if tick < history[history.size() - 1].tick: return null
    for i in range(history.size()):
        if tick >= history[i].tick:
            return history[i]
    return history[0]

func get_after(tick):
    if history.size() == 0: return null
    if tick > history[0].tick: return null
    for i in range(history.size()):
        if tick == history[i].tick:
            return history[i]
        if tick > history[i].tick:
            return history[i-1]
    return history[history.size() - 1]
