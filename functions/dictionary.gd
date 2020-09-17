class_name DictionaryFunctions

static func copy(dictionary : Dictionary, deep : bool = false) -> Dictionary:
    return dictionary.duplicate(deep)

static func add(dictionary : Dictionary, key, value) -> Dictionary:
    var result = copy(dictionary)
    result[key] = value
    return result

static func erase(dictionary : Dictionary, key) -> Dictionary:
    var result = copy(dictionary)
    result.erase(key)
    return result

static func update(dictionary : Dictionary, key, value) -> Dictionary:
    var result = copy(dictionary)
    result[key] = value
    return result

static func merge(destination: Dictionary, source: Dictionary) -> Dictionary:
    destination = destination.duplicate()
    for key in source:
        destination[key] = source[key]
    return destination

static func map(dictionary: Dictionary, func_ref : FuncRef) -> Dictionary:
    var result = {}
    for key in dictionary.keys():
        result[key] = func_ref.call_func(key, dictionary[key])
    return result

static func filter(dictionary: Dictionary, func_ref : FuncRef) -> Dictionary:
    var result = {}
    for key in dictionary:
        if func_ref.call_func(key, dictionary[key]):
            result[key] = dictionary[key]
    return result

static func not_filter(dictionary: Dictionary, func_ref : FuncRef) -> Dictionary:
    var result = {}
    for key in dictionary:
        if not func_ref.call_func(key, dictionary[key]):
            result[key] = dictionary[key]
    return result

static func reduce(dictionary: Dictionary, func_ref : FuncRef, initial_value = null):
    var accumulator = initial_value
    var start = 0
    if accumulator == null:
        accumulator = dictionary[dictionary.keys()[0]]
        start = 1
    for i in range(start, dictionary.keys().size()):
        var key = dictionary.keys()[i]
        accumulator = func_ref.call_func(accumulator, key, dictionary[key])
    return accumulator

static func map1(dictionary: Dictionary, func_ref : FuncRef, arg) -> Array:
    var result = {}
    for key in dictionary.keys():
        result[key] = func_ref.call_func(key, dictionary[key], arg)
    return result

static func find(dictionary: Dictionary, func_ref : FuncRef):
    for key in dictionary.keys():
        if dictionary[key] == func_ref.call_func(key, dictionary[key]):
            return dictionary[key]

static func find_key(dictionary: Dictionary, func_ref : FuncRef):
    for key in dictionary.keys():
        if dictionary[key] == func_ref.call_func(key, dictionary[key]):
            return key

static func copy_within(dictionary: Dictionary, from_key, to_key):
    dictionary = dictionary.duplicate()
    dictionary[to_key] = dictionary[from_key]
    return dictionary

static func some(dictionary: Dictionary, func_ref : FuncRef) -> bool:
    for key in dictionary.keys():
        if func_ref.call_func(key, dictionary[key]):
            return true
    return false

static func every(dictionary: Dictionary, func_ref : FuncRef) -> bool:
    for key in dictionary.keys():
        if func_ref.call_func(key, dictionary[key]):
            return false
    return true

static func filter_map_merge(dictionary: Dictionary, filter_func_ref: FuncRef, map_func_ref: FuncRef) -> Dictionary:
    return merge(dictionary.duplicate(), map(filter(dictionary, filter_func_ref), map_func_ref))
