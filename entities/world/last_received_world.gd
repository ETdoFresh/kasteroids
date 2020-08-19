extends Node2D

var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    pass

func receive(dictionary):
    create_new_entities(dictionary)
    remove_deleted_entities(dictionary)
    update_entities(dictionary)

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

func update_entities(dictionary):
    for entity in entity_list:
        var entry = get_dictionary_entry_by_id(dictionary, entity.id)
        entity.from_dictionary(entry)

func get_entity_by_id(id):
    for entity in entity_list:
        if entity.id == id:
            return entity
    return null

func get_dictionary_entry_by_id(dictionary, id):
    for entry in dictionary.objects:
        if entry.id == id:
            return entry
    return null

func create_entity(entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    containers[type].add_child(entity)
    entity.from_dictionary(entry)