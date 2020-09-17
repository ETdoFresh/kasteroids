class_name ObjectFunctions

const ASTEROID = AsteroidFunctions
const LIST = ListFunctions
const QUEUE_FREE = QueueFreeFunctions

static func id_equals(object: Dictionary, id: int) -> bool:
    return "id" in object and object.id == id

static func get_by_id(objects: Array, id: int):
    for object in objects:
        if id_equals(object, id):
            return object

static func set_by_id(objects: Array, id: int, new_object: Dictionary) -> Array:
    objects = objects.duplicate()
    for i in range(objects.size()):
        if not id_equals(objects[i], id): continue
        objects[i] = new_object
    return objects

static func assign_id(entity: Dictionary, state: Dictionary):
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

static func objects(state_property_name: String, state_value: Dictionary) -> bool:
    return state_property_name == "objects"
