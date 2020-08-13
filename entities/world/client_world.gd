extends Node2D

var dictionary = {}
var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    pass

func deserialize(serialized):
    dictionary = parse_json(serialized)
    create_new_entities()
    remove_deleted_entities()
    update_entities()

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
    containers[type].add_child(entity)
    entity.data.from_dictionary(entry)
