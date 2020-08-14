class_name Serializer
extends Node

var serialize_string : String
var entity_list : Array = []
var dictionary_list : Array = []
var tick = 0
var client_tick = 0
var offset = 0
var dictionary = {
    "tick": tick,
    "client_tick": client_tick,
    "offset": offset,
    "ship_id": -1,
    "objects": dictionary_list}

func serialize():
    if tick != dictionary.tick:
        dictionary_list.clear()
        for entity in entity_list:
            dictionary_list.append(entity.data.to_dictionary())
    
    serialize_string = to_json(dictionary)
    return serialize_string

func add_entity(entity):
    entity_list.append(entity)
    entity.data.id = ID.reserve()

func remove_entity(entity):
    entity_list.erase(entity)
    ID.release(entity.data.id)
