extends Node

export var snap_distance = 150

var interpolation_rate = 0.1
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
    
    create_instances(before, after)
    delete_instances(before, after)
    
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

func create_instances(before, after):
    for state in [before, after]:
        for child in state.children:
            if not container_has_id(child.container, child.id):
                var new_child = child.type.instance()
                var data = new_child.find_node("Data")
                child.container.add_child(new_child)
                data.id = child.id

func container_has_id(container, id):
    for child in container.get_children():
        var data = child.find_node("Data")
        if data.id == id:
            return true
    return false

func delete_instances(before, after):
    var ids = []
    for child in before.children: ids.append(child.id)
    for child in after.children: ids.append(child.id)
    for container in before.containers:
        for child in container.get_children():
            var data = child.find_node("Data")
            if data && ids.has(data.id):
                continue
            else:
                child.queue_free()

func get_interpolated_tick(tick, rtt, receive_rate):
    var target_iterpolation_rate = rtt # back to predicted_tick
    target_iterpolation_rate += max(rtt, receive_rate) * 1.5
    interpolation_rate = lerp(interpolation_rate, target_iterpolation_rate, 0.1)
    return tick - interpolation_rate * Settings.ticks_per_second
