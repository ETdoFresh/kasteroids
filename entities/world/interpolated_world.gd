extends Node2D

export var snap_distance = 150

var interpolation_rate = 0.1
var objects = []
var history = []
var received_data
var server_tick_sync
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    if received_data:
        add_history(received_data)
    if server_tick_sync:
        var interpolated_tick = get_interpolated_tick()
        interpolate(interpolated_tick)

func add_history(dictionary):
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick == dictionary.tick:
            history.remove(i)
    history.append(dictionary)
    dictionary = null

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
        for entry in before.objects:
            if entry:
                var node = List.lookup(objects, "id", entry.id)
                if node.is_inside_tree():
                    node.from_dictionary(entry)
        return
    
    var t = 0
    var numerator = tick - before.tick
    var denominator = after.tick - before.tick
    if denominator != 0: t = numerator / denominator
    
    var a
    var b
    for before_entry in before.objects:
        for after_entry in after.objects:
            if not before_entry || not after_entry:
                continue
            
            if before_entry.id == after_entry.id:
                var node = List.lookup(objects, "id", before_entry.id)
                if not node.is_inside_tree():
                    continue
                    
                a = before_entry.position
                b = after_entry.position
                var snap_t = t
                if (b - a).length() >= snap_distance: snap_t = round(snap_t)
                node.position = a.linear_interpolate(b, snap_t)
                
                a = before_entry.rotation
                b = after_entry.rotation
                node.rotation = lerp_angle(a, b, t)
                
                a = before_entry.scale
                b = after_entry.scale
                node.scale = a.linear_interpolate(b, t)

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
        for entry in state.objects:
            if entry:
                if not List.lookup(objects, "id", entry.id):
                    create_object(entry)

func delete_instances(before, after):
    for object in objects:
        if not List.lookup(before.objects, "id", object.id):
            if not List.lookup(after.objects, "id", object.id):
                delete_object(object)

func get_interpolated_tick():
    var tick = server_tick_sync.smooth_tick_rounded
    var rtt = server_tick_sync.rtt
    var receive_rate = server_tick_sync.receive_rate
    var target_iterpolation_rate = rtt # back to predicted_tick
    target_iterpolation_rate += max(rtt, receive_rate) * 1.5
    interpolation_rate = lerp(interpolation_rate, target_iterpolation_rate, 0.1)
    return tick - interpolation_rate * Settings.ticks_per_second

func create_object(entry):
    var type = entry.type
    var object = types[type].instance()
    objects.append(object)
    containers[type].add_child(object)
    object.from_dictionary(entry)

func delete_object(object):
    object.queue_free()
    objects.erase(object)
