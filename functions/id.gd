class_name IdFunctions

static func get_object_by_id(objects: Array, id: int) -> Dictionary:
    for object in objects:
        if "id" in object:
            if object.id == id:
                return object
    return {"id": id, "no_object_found": true}

static func assign_ids(objects: Array) -> Array:
    objects = objects.duplicate()
    for i in range(objects.size()):
        if not "id" in objects[i]: continue
        if objects[i].id >= 0: continue
        for j in range(10000):
            if not get_object_by_id(objects, j):
                objects[i] = objects[i].duplicate()
                objects[i].id = j
                break
    return objects

static func write_id_to_node(object: Dictionary) -> Dictionary:
    if "node" in object:
        object.node.id = object.id
    return object

static func set_object_by_id(objects: Array, id: int, object: Dictionary) -> Array:
    objects = objects.duplicate()
    for i in range(objects.size()):
        if objects[i].id == id:
            objects[i] = object.duplicate()
    return objects
