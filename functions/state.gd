class_name StateFunctions

static func map(list, func_ref): return ListFunctions.map(list, func_ref)
static func reduce(list, func_ref, new_state): return ListFunctions.reduce(list, func_ref, new_state)
static func exec_on(dict, key, func_ref, arg = null): return DictionaryFunctions.exec_on(dict, key, func_ref, arg)
static func map_on(dict, key, func_ref, arg = null): return DictionaryFunctions.map_on(dict, key, func_ref, arg)
static func merge(destination, source): return DictionaryFunctions.merge(destination, source)
static func update(dict, key, value): return DictionaryFunctions.update(dict, key, value)
static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": {}, "next_id": 1}

static func initial_state(children: Array):
    var result = children
    result = map(result, funcref(NodeFunctions, "to_dictionary"))
    result = reduce(result, funcref(ObjectFunctions, "assign_id"), empty_state())
    result = exec_on(result, "objects", funcref(InitializeFunctions, "randomize_asteroids"))
    result = exec_on(result, "objects", funcref(NodeFunctions, "update_sprite_scale")) # Side-effect)
    return result

static func simulate(state: Dictionary, delta: float, world: Node) -> Dictionary:
    var result = state
    result = merge(result, {"tick": state.tick + 1, "delta": delta, "world": world})
    result = exec_on(result, "objects", funcref(SimulateFunctions, "simulate_ships"), delta)
    result = add_bullets(result, world) # Side-effect
    result = exec_on(result, "objects", funcref(SimulateFunctions, "simulate_ship_fire"))
    result = exec_on(result, "objects", funcref(SimulateFunctions, "simulate_physics"), delta)
    result = map_on(result, "objects", funcref(WrapFunctions, "wrap"))
    result = map_on(result, "objects", funcref(SoundFunctions, "play_collision_sound")) # Side-effect
    result = map_on(result, "objects", funcref(BulletFunctions, "delete_on_collide"))
    result = map_on(result, "objects", funcref(BulletFunctions, "delete_on_timer"), delta)
    result = map_on(result, "objects", funcref(BulletFunctions, "spawn_bullet_particles_on_destroy"), world)
    result = map_on(result, "objects", funcref(NodeFunctions, "queue_free")) # Side-effect
    result = delete_objects(result)
    result = exec_on(result, "objects", funcref(NodeFunctions, "update_sprite_scale")) # Side-effect
    return result

static func add_bullets(state, world) -> Dictionary:
    var result = reduce(
        BulletFunctions.shoot_bullets(state.objects, world),
        funcref(ObjectFunctions, "assign_id"),
        update(state, "objects", {}))
    result = merge(result, state)
    return result

static func delete_objects(state) -> Dictionary:
    var result = reduce(
        filter(state.objects, funcref(QueueFreeFunctions, "is_queue_free")).keys(),
        funcref(ObjectFunctions, "erase_objects"),
        state)
    return result
