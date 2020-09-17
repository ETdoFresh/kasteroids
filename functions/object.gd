class_name ObjectFunctions

const ASTEROID = AsteroidFunctions
const LIST = ListFunctions
const QUEUE_FREE = QueueFreeFunctions

static func assign_id(state: Dictionary, entity: Dictionary):
    state = state.duplicate()
    state.objects = state.objects.duplicate()
    var key = state.next_id
    state.objects[key] = entity
    state.next_id += 1
    return state

static func queue_free(objects: Array) -> Array:
    if LIST.some(objects, funcref(QUEUE_FREE, "is_queue_free")):
        objects = LIST.not_filter(objects, funcref(QUEUE_FREE, "is_queue_free"))
    return objects

static func objects(key: String, _value: Dictionary) -> bool:
    return key == "objects"

static func erase_objects(state: Dictionary, id: int):
    return DictionaryFunctions.update(state, "objects", 
        DictionaryFunctions.erase(state.objects, id))
