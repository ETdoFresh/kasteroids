extends Node2D

export var interpolation_rate = 0.2
export var snap_distance = 150

var tick = 0
var target
var history = []

func _ready():
    if has_node("../Latest"):
        target = get_node("../Latest")
        target.visible = false

func _process(_delta):
    if not target: return
    faux_terpolate()
    #interpolate()
    
    visible = Settings.interpolation_enable
    target.visible = not Settings.interpolation_enable

func faux_terpolate():
    if position.distance_to(target.position) >= snap_distance:
        position = target.position
    else:
        position = lerp(position, target.position, interpolation_rate)
    
    if abs(rotation - target.rotation) >= PI:
        rotation = target.rotation
    else:
        rotation = lerp(rotation, target.rotation, interpolation_rate)
        
    scale = lerp(scale, target.scale, interpolation_rate)

func add_history(state):
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick == state.tick:
            history.remove(i)
    history.append(state)

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
