class_name ObjectFunctions

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

static func assign_ids(state: Dictionary):
    state = state.duplicate()
    if not "next_id" in state:
        state["next_id"] = 1
    state.objects = state.objects.duplicate()
    for i in range(state.objects.size()):
        var object = state.objects[i]
        if "id" in object and object.id > 0: continue
        object = object.duplicate()
        object.id = state.next_id
        state.next_id += 1
        state.objects[i] = object
    return state

static func write_id_to_node(object: Dictionary) -> Dictionary:
    if "node" in object:
        object.node.id = object.id
    return object
