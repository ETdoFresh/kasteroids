extends Node2D

export var smoothing_rate = 0.15

var dictionary = {}
var entity_list = []
var input = InputData.new()
var server_tick_sync
var last_received_tick = 0
var enable = true
var types = {
    "Ship": Scene.SHIP,
    "Asteroid": Scene.ASTEROID,
    "Bullet": Scene.BULLET }

onready var extrapolated_world = get_parent().get_node("ExtrapolatedWorld")
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    if not enable: return
    for entity in entity_list:
        var other_entity = extrapolated_world.get_entity_by_id(entity.data.id)
        if other_entity != null:
            if entity.has_method("linear_interpolate"):
                pass
                entity.linear_interpolate(other_entity, smoothing_rate)

func deserialize(serialized):
    if not enable: return
    dictionary = parse_json(serialized)
    if dictionary.tick < last_received_tick:
        return
    else:
        last_received_tick = dictionary.tick
    
    create_new_entities()
    remove_deleted_entities()
    
    for entity in entity_list:
        var entry = get_dictionary_entry_by_id(entity.data.id)
        entity.data.from_dictionary(entry)
        
        if entry.type in ["\"Asteroid\"", "\"Bullet\""]:
            entity.linear_velocity = entity.data.linear_velocity
            entity.angular_velocity = entity.data.angular_velocity
            entity.data.instance_name = entity.data.instance_name

func create_new_entities():
    for entry in dictionary.entries:
        var entity = get_entity_by_id(entry.id)
        if not entity:
            create_entity(entry)

func remove_deleted_entities():
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not get_dictionary_entry_by_id(entity.data.id):
            entity_list.remove(i)
            entity.queue_free()

func update_entities():
    for entity in entity_list:
        var entry = get_dictionary_entry_by_id(entity.data.id)
        entity.data.from_dictionary(entry)
        entity.data.apply(entity)

func get_entity_by_id(id):
    for entity in entity_list:
        if entity.data.id == int(id):
            return entity
    return null

func get_dictionary_entry_by_id(id):
    for entry in dictionary.entries:
        if int(entry.id) == id:
            return entry
    return null

func create_entity(entry):
    var type = entry.type.replace("\"", "")
    var entity = types[type].instance()
    entity_list.append(entity)
    entity.collision_layer = Data.get_physics_layer_id_by_name("client")
    entity.collision_mask = Data.get_physics_layer_id_by_name("client")
    entity.connect("tree_exited", self, "erase_entity", [entity])
    containers[type].add_child(entity)
    entity.data.from_dictionary(entry)
    
    if type == "Ship":
        if entity.data.id == dictionary.ship_id:
            entity.input = input

func erase_entity(entity):
    entity_list.erase(entity)
