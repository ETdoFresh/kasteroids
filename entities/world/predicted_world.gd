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
var types = {
    "Ship": Scene.SHIP,
    "Asteroid": Scene.ASTEROID,
    "Bullet": Scene.BULLET }

onready var extrapolated_world = get_parent().get_node("ExtrapolatedWorld")
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    tick = server_tick_sync.smooth_tick_rounded
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.update_input(input)
    history.append(to_dictionary())

func receive(received):
    if received.tick < last_received_tick:
        return
    else:
        last_received_tick = received.tick
    
    ship_id = received.client.ship_id
    create_new_entities(received)
    remove_deleted_entities(received)
    
    var historical_state = lookup(history, "tick", received.tick)
    
    for object in historical_state.objects:
        var other_object = lookup(received.objects, "id", object.id)
        if not other_object:
            continue
        var delta = get_delta(object, other_object)
        for i in range(received.tick, tick + 1):
            var historical_entry = lookup(history, "tick", i)
            if historical_entry == null:
                continue
            var historical_object = lookup(historical_entry.objects, "id", object.id)
            if historical_object == null: 
                continue
            apply_delta(historical_object, delta)
        
        var entity = lookup(entity_list, "id", object.id)
        if entity == null:
            continue
        var current_state = lookup(history, "tick", tick)
        if not current_state:
            continue
        var current_object = lookup(current_state.objects, "id", object.id)
        if not current_object:
            continue
        entity.from_dictionary(current_object)
        continue
    
    for i in range(history.size() - 1, -1, -1):
        if history[i].tick < received.tick:
            history.remove(i)
    
    if not enable:
        return

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
    var input_dict = Data.instance_to_dictionary(input)
    return {"tick": tick, "input": input_dict, "objects": objects}
