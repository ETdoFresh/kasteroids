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

onready var extrapolated_world = get_parent().get_node("ExtrapolatedWorld")
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(delta):
    tick = server_tick_sync.smooth_tick_rounded
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.update_input(input)
    for entity in entity_list:
        entity.simulate(delta)
    history.append(to_dictionary())

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
    
    ship_id = received.client.ship_id
    create_new_entities(received)
    remove_deleted_entities(received)
    
    var historical_state = lookup(history, "tick", received.tick)
    
    var is_miss = false
    for object in historical_state.objects:
        var other_object = lookup(received.objects, "id", object.id)
        if not other_object:
            continue
        var delta = get_delta(object, other_object)
        if delta.position.length() >= 0.1 || delta.rotation >= 1:
            is_miss = true
            break
    
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick < received.tick:
            history.remove(i)
    
    if is_miss:
        misses += 1
        rewrite(historical_state, received)
        rewind_to(historical_state)
        for historical_tick in range(historical_state.tick, server_tick_sync.smooth_tick + 1):
            var historical_state2 = lookup(history, "tick", historical_tick)
            resimulate(historical_state2)

func get_delta(source, target):
    var delta = {}
    if "position" in source && "position" in target:
        delta["position"] = target.position - source.position
    if "rotation" in source && "rotation" in target:
        delta["rotation"] = target.rotation - source.rotation
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
        if not entity:
            create_entity(entry)

func remove_deleted_entities(dictionary):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not lookup(dictionary.objects, "id", entity.id):
            entity_list.remove(i)
            entity.queue_free()

func create_entity(entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    entity.collision_layer = Data.get_physics_layer_id_by_name("client")
    entity.collision_mask = Data.get_physics_layer_id_by_name("client")
    entity.connect("tree_exited", self, "erase_entity", [entity])
    entity.from_dictionary(entry)
    containers[type].add_child(entity)

func erase_entity(entity):
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
