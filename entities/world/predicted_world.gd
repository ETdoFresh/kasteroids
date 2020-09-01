extends Node2D

export var enable = true
export var smoothing_rate = 0.15

var tick = 0
var entity_list = []
var ship_id = -1
var input = InputData.new()
var server_tick_sync
var last_received_tick = 0
var history = []
var misses = 0
var types = {
    "Ship": Scene.SHIP,
    "Asteroid": Scene.ASTEROID,
    "Bullet": Scene.BULLET }
var create_list = []
var delete_list = []
var local_id = 0

onready var screen_size = get_viewport().get_visible_rect().size 
onready var extrapolated_world = get_parent().get_node("ExtrapolatedWorld")
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func _enter_tree():
    CSV.write_line("res://predicted_world.csv",
     ["Action","Tick","Horizontal","Vertical","Fire","Name1","Position1X","Position1Y","Rotation1","Name2","Position2X","Position2Y","Rotation2",
      "Name3","Position3X","Position3Y","Rotation3","Name4","Position4X","Position4Y","Rotation4","Name5","Position5X","Position5Y","Rotation5"])

func simulate(delta):
    tick = server_tick_sync.smooth_tick_rounded
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.update_input(input)
    for entity in entity_list:
        entity.simulate(delta)
    for item in create_list:
        if item.entity:
            item.entity.simulate(delta)
    history.append(to_dictionary())
    to_log("Simulate", tick, input, entity_list)

func rewrite(state, new_state):
    state.objects = new_state.objects

func rewind_to(state):
    for object in state.objects:
        var entity = lookup(entity_list, "id", object.id)
        if entity == null:
            continue
        var state_object = lookup(state.objects, "id", object.id)
        if not state_object:
            continue
        entity.from_dictionary(state_object)

func resimulate(state):
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.update_input(state.input)
    for entity in entity_list:
        entity.simulate(Settings.tick_rate)
    state.objects = to_dictionary().objects

func receive(received):
    if received.tick < last_received_tick:
        return
    else:
        last_received_tick = received.tick
   
    to_log("Received", received.tick, input, received.objects)
    ship_id = received.client.ship_id
    create_new_entities(received)
    remove_deleted_entities(received)
    
    for i in range(create_list.size() - 1, -1, -1):
        if create_list[i].tick < received.tick:
            if create_list[i].id == -1:
                if create_list[i].entity:
                    create_list[i].entity.queue_free()
            create_list.remove(i)
    
    for i in range(delete_list.size() - 1, -1, -1):
        if delete_list[i].tick < received.tick:
            delete_list.remove(i)
    
    var historical_state = lookup(history, "tick", received.tick)
    var is_miss = false
    
    if historical_state:
        for object in historical_state.objects:
            var other_object = lookup(received.objects, "id", object.id)
            if not other_object:
                continue
            var delta = get_delta(object, other_object)
            if delta.position.length() >= 2 || delta.rotation >= 0.05:
                is_miss = true
                break
    else:
        is_miss = true
    
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick < received.tick:
            history.remove(i)
    
    if is_miss && historical_state:
        misses += 1
        to_log("Rewind", historical_state.tick, historical_state.input, historical_state.objects)
        rewrite(historical_state, received)
        rewind_to(historical_state)
        to_log("Rewrite", historical_state.tick, historical_state.input, historical_state.objects)
        for historical_tick in range(historical_state.tick + 1, server_tick_sync.smooth_tick + 1):
            var historical_state2 = lookup(history, "tick", historical_tick)
            resimulate(historical_state2)
            to_log("Resimulate", historical_state2.tick, historical_state2.input, historical_state2.objects)

func get_delta(source, target):
    var delta = {}
    if "position" in source && "position" in target:
        var delta_x = target.position.x - source.position.x
        if abs(target.position.x - (source.position.x + screen_size.x)) < abs(delta_x):
            delta_x = target.position.x - (source.position.x + screen_size.x)
        if abs(target.position.x - (source.position.x - screen_size.x)) < abs(delta_x):
            delta_x = target.position.x - (source.position.x - screen_size.x)
        var delta_y = target.position.y - source.position.y
        if abs(target.position.y - (source.position.y + screen_size.y)) < abs(delta_y):
            delta_y = target.position.y - (source.position.y + screen_size.y)
        if abs(target.position.y - (source.position.y - screen_size.y)) < abs(delta_y):
            delta_y = target.position.y - (source.position.y - screen_size.y)
        delta["position"] = Vector2(delta_x, delta_y)
    if "rotation" in source && "rotation" in target:
        var delta_rotation = target.rotation - source.rotation
        if abs(target.rotation - (source.rotation - 2 * PI)) < abs(delta_rotation):
            delta_rotation = target.rotation - (source.rotation - 2 * PI)
        if abs(target.rotation - (source.rotation - 2 * PI)) < abs(delta_rotation):
            delta_rotation = target.rotation - (source.rotation - 2 * PI)
        delta["rotation"] = delta_rotation
    if "scale" in source && "scale" in target:
        delta["scale"] = target.scale - source.scale
    if "linear_velocity" in source && "linear_velocity" in target:
        delta["linear_velocity"] = target.linear_velocity - source.linear_velocity
    if "angular_velocity" in source && "angular_velocity" in target:
        delta["angular_velocity"] = target.angular_velocity - source.angular_velocity
    return delta

func apply_delta(source, delta):
    if source is Node && source.has_method("apply_delta"):
        source.apply_delta(delta)
        return
    
    if "position" in source && "position" in delta:
        source["position"] += delta.position
    if "rotation" in source && "rotation" in delta:
        source["rotation"] += delta.rotation
    if "scale" in source && "scale" in delta:
        source["scale"] += delta.scale
    if "linear_velocity" in source && "linear_velocity" in delta:
        source["linear_velocity"] += delta.linear_velocity
    if "angular_velocity" in source && "angular_velocity" in delta:
        source["angular_velocity"] += delta.angular_velocity

func create_new_entities(dictionary):
    for entry in dictionary.objects:
        var entity = lookup(entity_list, "id", entry.id)
        var on_delete_list = lookup(delete_list, "id", entry.id)
        if not entity && not on_delete_list:
            create_entity(entry)

func remove_deleted_entities(dictionary):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not lookup(dictionary.objects, "id", entity.id):
            entity_list.remove(i)
            entity.queue_free()

func create_entity(entry):
    var type = entry.type
    var entity = claim_new_entity(entry)
    if not entity:
        entity = types[type].instance()
        entity.collision_layer = Data.get_physics_layer_id_by_name("predicted_world")
        entity.collision_mask = Data.get_physics_layer_id_by_name("predicted_world")
        entity.connect("tree_exited", self, "erase_entity", [entity])
        entity.from_dictionary(entry)
        entity_list.append(entity)
        containers[type].add_child(entity)
        if type == "Bullet" && "ship_id" in entry:
            var ship = lookup(entity_list, "id", ship_id)
            if ship:
                entity.add_collision_exception_with(ship)
        if entity.has_signal("bullet_created"):
            entity.connect("bullet_created", self, "create_bullet")

func erase_entity(entity):
    var created_entity = lookup(create_list, "entity", entity)
    var created_local_id = created_entity.local_id if created_entity else -1
    delete_list.append({"tick": tick, "id": entity.id, "local_id": created_local_id})
    entity_list.erase(entity)

func lookup(list, key, value):
    for item in list:
        if key in item:
            if item[key] == value:
                return item
    return null

func to_dictionary():
    var objects = []
    for entity in entity_list:
        objects.append(entity.to_dictionary())
    var input_dict = inst2dict(input)
    return {"tick": tick, "input": input_dict, "objects": objects}

func to_log(action, log_tick, log_input, objects):
    var values = []
    values.append(action)
    values.append(log_tick)
    values.append(log_input.horizontal)
    values.append(log_input.vertical)
    values.append(log_input.fire)
    for object in objects:
        values.append(object.name if "name" in object else object.type)
        values.append(object.position)
        values.append(object.rotation)
    CSV.write_line("res://predicted_world.csv", values)

func claim_new_entity(entry):
    var unclaimed = lookup(create_list, "id", -1)
    if unclaimed:
        unclaimed.id = entry.id
        var deleted_entity = lookup(delete_list, "local_id", unclaimed.local_id)
        if deleted_entity:
            deleted_entity.id = entry.id
        
        var entity = unclaimed.entity
        if entity:
            entity.id = entry.id
            entity_list.append(entity)
            return entity
        else:
            return true

func create_bullet(bullet):
    create_list.append({"tick": tick, "id": -1, "local_id": local_id, "entity": bullet})
    local_id += 1
    bullet.collision_layer = Data.get_physics_layer_id_by_name("predicted_world")
    bullet.collision_mask = Data.get_physics_layer_id_by_name("predicted_world")
    bullet.connect("tree_exited", self, "erase_entity", [bullet])
    
    for other_bullet in $Bullets.get_children():
        bullet.add_collision_exception_with(other_bullet)
    
    $Bullets.add_child(bullet)
