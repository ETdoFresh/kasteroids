extends Node

export var snap_distance = 150

var interpolation_rate = 0.1
var history = []
var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": get_parent().get_node("Ships"), 
    "Asteroid": get_parent().get_node("Asteroids"),  
    "Bullet": get_parent().get_node("Bullets") }

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
        for entry in before.objects:
            var node = get_entity_by_id(entry.id)
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
            if before_entry.id == after_entry.id:
                var node = get_entity_by_id(before_entry.id)
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
            if not get_entity_by_id(entry.id):
                create_entity(entry)

func delete_instances(before, after):
    for entity in entity_list:
        if not get_dictionary_entry_by_id(before, entity.id):
            if not get_dictionary_entry_by_id(after, entity.id):
                delete_entity(entity)

func get_interpolated_tick(tick, rtt, receive_rate):
    var target_iterpolation_rate = rtt # back to predicted_tick
    target_iterpolation_rate += max(rtt, receive_rate) * 1.5
    interpolation_rate = lerp(interpolation_rate, target_iterpolation_rate, 0.1)
    return tick - interpolation_rate * Settings.ticks_per_second

func get_entity_by_id(id):
    for entity in entity_list:
        if entity.id == int(id):
            return entity
    return null

func get_dictionary_entry_by_id(dictionary, id):
    for entry in dictionary.objects:
        if int(entry.id) == id:
            return entry
    return null

func create_entity(entry):
    var type = entry.type.replace("\"", "")
    var entity = types[type].instance()
    entity_list.append(entity)
    containers[type].add_child(entity)
    entity.from_dictionary(entry)

func delete_entity(entity):
    entity.queue_free()
    entity_list.erase(entity)
