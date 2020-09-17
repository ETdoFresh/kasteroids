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
    return exec_on(exec_on(reduce(map(children,
        funcref(NodeFunctions, "to_dictionary")),
        funcref(ObjectFunctions, "assign_id"), empty_state()),
        "objects", funcref(InitializeFunctions, "randomize_asteroids")),
        "objects", funcref(NodeFunctions, "update_sprite_scale")) # Side-effect

static func simulate(state: Dictionary, delta: float, world: Node) -> Dictionary:
    return exec_on(delete_objects(map_on(map_on(map_on(map_on(map_on(map_on(exec_on(add_bullets(exec_on(merge(state,
        {"tick": state.tick + 1, "delta": delta, "world": world}),
        "objects", funcref(SimulateFunctions, "simulate_ships"), delta), 
        world), # add_bullets() # Side-effect
        "objects", funcref(SimulateFunctions, "simulate_physics"), delta), 
        "objects", funcref(WrapFunctions, "wrap")),
        "objects", funcref(SoundFunctions, "play_collision_sound")), # Side-effect
        "objects", funcref(BulletFunctions, "delete_on_collide")),
        "objects", funcref(BulletFunctions, "delete_on_timer"), delta),
        "objects", funcref(BulletFunctions, "spawn_bullet_particles_on_destroy"), world), # Side-effect
        "objects", funcref(NodeFunctions, "queue_free")) # Side-effect
        ), # delete_objects()
        "objects", funcref(NodeFunctions, "update_sprite_scale")) # Side-effect

static func add_bullets(state, world) -> Dictionary:
    return merge(state, reduce(
        BulletFunctions.shoot_bullets(state.objects, world),
        funcref(ObjectFunctions, "assign_id"),
        update(state, "objects", {})))

static func delete_objects(state) -> Dictionary:
    return reduce(
        filter(state.objects, funcref(QueueFreeFunctions, "is_queue_free")).keys(),
        funcref(ObjectFunctions, "erase_objects"),
        state)
