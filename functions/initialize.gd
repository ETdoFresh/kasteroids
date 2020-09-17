class_name InitializeFunctions

static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
static func update(dict, key, value): return DictionaryFunctions.update(dict, key, value)
static func map(dict, func_ref): return DictionaryFunctions.map(dict, func_ref)
static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)

static func randomize_asteroids(key, state: Dictionary):
    return update(state, "objects", 
        merge(state.objects,
        map(map(map(filter(state.objects, 
        funcref(AsteroidFunctions, "is_asteroid")),
        funcref(AsteroidFunctions, "randomize_linear_velocity")),
        funcref(AsteroidFunctions, "randomize_angular_velocity")),
        funcref(AsteroidFunctions, "randomize_scale"))))
