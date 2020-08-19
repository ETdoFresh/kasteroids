extends Node2D

var input = InputData.new()
var last_tick_received = 0
var server_tick_sync
var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    if server_tick_sync:    
        var time = (server_tick_sync.smooth_tick - last_tick_received) * Settings.tick_rate
        for entity in entity_list:
            if entity.has_meta("extrapolated_position"):
                entity.position = entity.get_meta("extrapolated_position")
                entity.position += entity.get_meta("linear_velocity") * time
                entity.rotation = entity.get_meta("extrapolated_rotation")
                entity.rotation += entity.get_meta("angular_velocity") * time

func receive(dictionary):
    if dictionary.tick < last_tick_received:
        return
    else:
        last_tick_received = dictionary.tick
    
    create_new_entities(dictionary)
    remove_deleted_entities(dictionary)
    
    for entity in entity_list:
        var entry = get_dictionary_entry_by_id(dictionary, entity.id)
        entity.set_meta("extrapolated_position", entry.position)
        entity.set_meta("extrapolated_rotation", entry.rotation)
        entity.set_meta("linear_velocity", entry.linear_velocity)
        entity.set_meta("angular_velocity", entry.angular_velocity)
        entity.scale = entry.scale

func create_new_entities(dictionary):
    for entry in dictionary.objects:
        var entity = get_entity_by_id(entry.id)
        if not entity:
            create_entity(entry)

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

func create_entity(entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    containers[type].add_child(entity)
    entity.from_dictionary(entry)
