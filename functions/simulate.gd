class_name SimulateFunctions

static func map(dict, func_ref, arg = null): return DictionaryFunctions.map(dict, func_ref, arg)
static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)
static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
static func reduce(dict, func_ref, acc): return DictionaryFunctions.reduce(dict, func_ref, acc)

static func simulate_ships(_key, objects, delta):
    return merge(objects,
        map(filter(objects, 
        funcref(ShipFunctions, "is_ship")),
        funcref(ShipFunctions, "simulate"), delta))

static func simulate_physics(_key, objects: Dictionary, delta: float) -> Dictionary:
    objects = objects.duplicate()
    objects = map(objects, funcref(PhysicsFunctions, "move"), delta)
    objects = map(objects, funcref(PhysicsFunctions, "update_physical_body")) # Side-effect
    objects = map(objects, funcref(CollisionFunctions, "clear_collisions"))
    objects = map(objects, funcref(BoundingBoxFunctions, "set_bounding_box"))
    objects = reduce(objects, funcref(CollisionFunctions, "broad_phase"), objects)
    objects = reduce(objects, funcref(CollisionFunctions, "narrow_phase"), objects)
    objects = map(objects, funcref(CollisionFunctions, "fix_penetration"))
    objects = map(objects, funcref(CollisionFunctions, "bounce_no_angular_velocity"))
    return objects

static func simulate_wrap(_key, objects):
    return map(objects, funcref(WrapFunctions, "wrap"))

static func simulate_sound(_key, objects):
    return map(objects, funcref(SoundFunctions, "play_collision_sound"))
