extends Node

var assign_id = funcref(self, "_assign_id")
var queue_delete = funcref(self, "_queue_delete")
var erase_objects = funcref(self, "_erase_objects")

static func _assign_id(state: Dictionary, entity: Dictionary):
    state = state.duplicate()
    state.objects = state.objects.duplicate()
    var key = state.next_id
    state.objects[key] = entity
    state.next_id += 1
    return state

static func _queue_delete(objects: Array) -> Array:
    if some(objects, NodeFunc.is_queue_delete):
        objects = not_filter(objects, NodeFunc.is_queue_delete)
    return objects

static func objects(key: String, _value: Dictionary) -> bool:
    return key == "objects"

static func _erase_objects(state: Dictionary, id: int):
    return DictionaryFunctions.update(state, "objects", 
        DictionaryFunctions.erase(state.objects, id))

static func some(list, func_ref): return ListFunctions.some(list, func_ref)
static func not_filter(list, func_ref): return ListFunctions.not_filter(list, func_ref)
