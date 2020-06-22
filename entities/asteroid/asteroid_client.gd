class_name AsteroidClient
extends Node2D

var tick = 0
var history = []

func _process(_delta):
    interpolate()

func receive_update(state):
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick == state.tick:
            history.remove(i)
    history.append(state)
    
    if get_node("Latest"):
        $Latest.position = state.position
        $Latest.rotation = state.rotation
        $Latest.scale = state.scale

func interpolate():
    var before = get_before()
    var after = get_after()

    if before == null && after == null: return
    if before == null: before = after
    if after == null: after = before
    
    var t = 0
    var numerator = tick - before.tick
    var denominator = after.tick - before.tick
    if denominator != 0: t = numerator / denominator
    
    var a = before.position
    var b = after.position
    $Interpolated.position = a.linear_interpolate(b, t)
    
    a = before.rotation
    b = after.rotation
    $Interpolated.rotation = lerp(a, b, t)
    
    a = before.scale
    b = after.scale
    $Interpolated.scale = a.linear_interpolate(b, t)

func get_before():
    var before = null
    for item in history:
        if item.tick < tick:
            if before == null || before.tick < item.tick:
                before = item
    return before

func get_after():
    var after = null
    for item in history:
        if item.tick >= tick:
            if after == null || after.tick > item.tick:
                after = item
    return after
