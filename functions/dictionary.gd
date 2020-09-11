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
