extends Node2D

var input = Data.NULL_INPUT
var dictionary = {}
var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    pass

func deserialize(serialized):
    dictionary = parse_json(serialized)
    
    for entry in dictionary.entries:
        var entity = get_entity_by_id(entry.id)
        if not entity:
            create_entity(entry)
        else:
            entity.data.from_dictionary(entry)
    
    for entity in entity_list:
        if not get_dictionary_entry_by_id(entity.data.id):
            delete_entity(entity)
    
    for entity in entity_list:
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
    containers[type].add_child(entity)
    entity.data.from_dictionary(entry)

func delete_entity(entity):
    entity.queue_free()
    entity_list.erase(entity)
