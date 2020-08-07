extends Node

export var snap_distance = 150

var history = []

func add_history(state):
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick == state.tick:
            history.remove(i)
    history.append(state)

func interpolate(tick):
    var before = get_before(tick)
    var after = get_after(tick)
    
    if before != null:
        for i in range(history.size() - 1, -1, -1):
            if history[i].tick < before.tick:
                history.remove(i)
    
    if before == null && after == null: return
    if before == null: before = after
    if after == null: after = before
    
    if before == after:
        for child in before.children:
            if child.node && child.node.is_inside_tree():
                child.node.position = child.position
                child.node.rotation = child.rotation
                child.node.scale = child.scale
        return
    
    var t = 0
    var numerator = tick - before.tick
    var denominator = after.tick - before.tick
    if denominator != 0: t = numerator / denominator
    
    var a
    var b
    for before_child in before.children:
        for after_child in after.children:
            if before_child.node == after_child.node:
                if not before_child.node || not before_child.node.is_inside_tree():
                    continue
                    
                a = before_child.position
                b = after_child.position
                var snap_t = t
                if (b - a).length() >= snap_distance: snap_t = round(snap_t)
                before_child.node.position = a.linear_interpolate(b, snap_t)
                
                a = before_child.rotation
                b = after_child.rotation
                before_child.node.rotation = lerp_angle(a, b, t)
                
                a = before_child.scale
                b = after_child.scale
                before_child.node.scale = a.linear_interpolate(b, t)

func get_before(tick):
    var before = null
    for item in history:
        if item.tick < tick:
            if before == null || before.tick < item.tick:
                before = item
    return before

func get_after(tick):
    var after = null
    for item in history:
        if item.tick >= tick:
            if after == null || after.tick > item.tick:
                after = item
    return after


