extends Node

const USERNAME_PATH = "user://local_storage_username.tres"
const INPUT_VARIABLES = ["horizontal", "vertical", "fire", "next_state", "previous_state"]
const ID = {}
const NULL_INPUT = {
    "horizontal": 0, 
    "vertical": 0, 
    "fire": false, 
    "next_state": false, 
    "previous_state": false,
    "input_name": "Null Input"
}

func copy_values(keys, source, destination):
    for key in keys:
        if key in source && key in destination:
            destination[key] = source[key]

func get_physics_layer_id_by_name(layer_name):
    for i in range(1, 21):
        var settings_layer_name = ProjectSettings.get_setting(
            str("layer_names/2d_physics/layer_", i))
        if layer_name == settings_layer_name:
            return i
    return 0

func get_id(category):
    if ID.has(category):
        var id = ID[category][0]
        ID[category].remove(0)
        return id
    else:
        ID[category] = []
        for i in range(256): ID[category].append(i)
        var id = ID[category][0]
        ID[category].remove(0)
        return id

func return_id(category, id):
    if ID.has(category):
        ID[category].append(id)

func get_username():
    var username_resource
    if ResourceLoader.exists(USERNAME_PATH):
        username_resource = ResourceLoader.load(USERNAME_PATH)
    if username_resource == null:
        randomize()
        username_resource = set_username("Guest%03d" % (randi() % 1000))
    elif username_resource.value == "" || username_resource.value == null:
        randomize()
        username_resource["value"] = "Guest%03d" % (randi() % 1000)
        var _1 = ResourceSaver.save(USERNAME_PATH, username_resource)
    return username_resource.value

func set_username(username):
    var username_resource = Username.new(username)
    username_resource.resource_path = USERNAME_PATH
    var _1 = ResourceSaver.save(USERNAME_PATH, username_resource)
    return username_resource

func serialize_Vector2(v : Vector2):
    return "%f,%f," % [v.x, v.y]

func serialize_float(v : float):
    return "%f," % v

func serialize_int(v : int):
    return "%d," % v

func serialize_string(v : String):
    return v.replace(",", "{comma}") + ","

func deserialize_Vector2(queue : PoolStringQueue):
    return Vector2(float(queue.pop_front()), float(queue.pop_front()))

func deserialize_float(queue : PoolStringQueue):
    return float(queue.pop_front())

func deserialize_int(queue : PoolStringQueue):
    return int(queue.pop_front())

func deserialize_string(queue : PoolStringQueue):
    return queue.pop_front().replace("{comma}", ",")
    
func instance_to_dictionary(instance):
    var dictionary = inst2dict(instance)
    for key in dictionary.keys():
        if key in instance:
            dictionary[key] = var2str(instance[key])
    return dictionary

func dictionary_to_instance(dictionary, instance):
    for key in dictionary.keys():
        if key in instance:
            instance[key] = str2var(dictionary[key])

func instance_to_json(instance):
    return to_json(instance_to_dictionary(instance))

func json_to_instance(json, instance):
    var dictionary = parse_json(json)
    dictionary_to_instance(dictionary, instance)

func instance_to_bytes(instance):
    return var2bytes(instance_to_dictionary(instance))

func bytes_to_instance(bytes, instance):
    var dictionary = bytes2var(bytes)
    dictionary_to_instance(dictionary, instance)

func instance_to_csv(_instance):
    # TODO: I'll think about this one....
    return null
