extends Node2D

export var smoothing_rate = 0.15

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
        var other_entity = extrapolated_world.get_entity_by_id(entity.id)
        if other_entity != null:
            if entity.has_method("linear_interpolate"):
                return
                entity.linear_interpolate(other_entity, smoothing_rate)

func receive(dictionary):
    if not enable: return
    if dictionary.tick < last_received_tick:
        return
    else:
        last_received_tick = dictionary.tick
    
    create_new_entities(dictionary)
    remove_deleted_entities(dictionary)
    
    for entity in entity_list:
        var entry = get_dictionary_entry_by_id(dictionary, entity.id)
        entity.from_dictionary(entry)
        
        if entry.type in ["\"Asteroid\"", "\"Bullet\""]:
            entity.linear_velocity = entry.linear_velocity
            entity.angular_velocity = entry.angular_velocity

func create_new_entities(dictionary):
    for entry in dictionary.objects:
        var entity = get_entity_by_id(entry.id)
        if not entity:
            create_entity(dictionary, entry)

func remove_deleted_entities(dictionary):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not get_dictionary_entry_by_id(dictionary, entity.id):
            entity_list.remove(i)
            entity.queue_free()

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

func create_entity(dictionary, entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    entity.collision_layer = Data.get_physics_layer_id_by_name("client")
    entity.collision_mask = Data.get_physics_layer_id_by_name("client")
    entity.connect("tree_exited", self, "erase_entity", [entity])
    containers[type].add_child(entity)
    entity.from_dictionary(entry)
    
    if entity.id == dictionary.client.ship_id:
        entity.input = input

func erase_entity(entity):
    entity_list.erase(entity)
