extends Node

const USERNAME_PATH = "user://local_storage_username.tres"
const ID = {}

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
    
func instance_to_dictionary(instance, keys = null):
    var dictionary = inst2dict(instance).duplicate(true)
    var2strs(dictionary)
    for key in dictionary.keys():
        if not key in instance || (keys != null && not keys.has(key)):
            dictionary.erase(key)
    return dictionary

func dictionary_to_instance(dictionary, instance):
    for key in dictionary.keys():
        if key in instance:
            instance[key] = str2var(dictionary[key])

func instance_to_json(instance, keys = null):
    return to_json(instance_to_dictionary(instance, keys))

func json_to_instance(json, instance):
    var dictionary = parse_json(json)
    dictionary_to_instance(dictionary, instance)

func instance_to_bytes(instance):
    return var2bytes(instance_to_dictionary(instance))

func bytes_to_instance(bytes, instance):
    var dictionary = bytes2var(bytes)
    dictionary_to_instance(dictionary, instance)

func list_to_csv(list):
    var csv = ""
    for item in list:
        csv += "%s," % item
    return csv

func csv_to_list(csv):
    return csv.split(",", false)

func str2vars_json(json):
    return str2vars(parse_json(json))

func str2vars(variant):
    if variant is Dictionary:
        return str2vars_dictionary(variant)
    elif variant is Array:
        return str2vars_array(variant)
    else:
        return str2var(variant)

func str2vars_dictionary(dictionary):
    for key in dictionary.keys():
        var value = dictionary[key]
        if value is Dictionary:
            str2vars_dictionary(value)
        elif value is Array:
            str2vars_array(value)
        elif value is String:
            dictionary[key] = str2var(value)
    return dictionary

func str2vars_array(array):
    for i in range(array.size()):
        var value = array[i]
        if value is Dictionary:
            str2vars_dictionary(value)
        elif value is Array:
            str2vars_array(value)
        else:
            array[i] = str2var(value)
    return array

func var2strs_json(variant):
    return to_json(var2strs(variant))

func var2strs(variant):
    if variant is Dictionary:
        return var2strs_dictionary(variant)
    elif variant is Array:
        return var2strs_array(variant)
    elif variant is Node && variant.has_method("to_dictionary"):
        return var2strs_dictionary(variant.to_dictionary())
    else:
        return var2str(variant)

func var2strs_dictionary(dictionary):
    for key in dictionary.keys():
        var value = dictionary[key]
        if value is Dictionary:
            var2strs_dictionary(value)
        elif value is Array:
            var2strs_array(value)
        elif value is Node && value.has_method("to_dictionary"):
            dictionary[key] = var2strs_dictionary(value.to_dictionary())
        elif value is int:
            pass
        elif value is float:
            pass
        else:
            dictionary[key] = var2str(value)
    return dictionary

func var2strs_array(array):
    for i in range(array.size()):
        var value = array[i]
        if value is Dictionary:
            var2strs_dictionary(value)
        elif value is Array:
            var2strs_array(value)
        elif value is Node && value.has_method("to_dictionary"):
            array[i] = var2strs_dictionary(value.to_dictionary())
        elif value is int:
            pass
        elif value is float:
            pass
        else:
            array[i] = var2str(value)
    return array
