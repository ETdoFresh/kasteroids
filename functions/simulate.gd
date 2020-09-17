class_name SimulateFunctions

static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
static func update(dict, key, value): return DictionaryFunctions.update(dict, key, value)
static func map1(dict, func_ref, arg): return DictionaryFunctions.map1(dict, func_ref, arg)
static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)

static func simulate_ships(key, state: Dictionary):
    return update(state, "objects", 
        merge(state.objects,
        map1(filter(state.objects, 
        funcref(ShipFunctions, "is_ship")),
        funcref(ShipFunctions, "simulate"), state.delta)))
