class_name StateFunctions

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": {}, "next_id": 1}

static func initial_state(children: Array):
    return map(map(list_reduce(list_map(children,
        funcref(NodeFunctions, "to_dictionary")),
        funcref(ObjectFunctions, "assign_id"), empty_state()),
        funcref(InitializeFunctions, "randomize_asteroids")),
        funcref(NodeFunctions, "update_display")) # Side-effect

static func simulate(state: Dictionary, delta: float, world: Node) -> Dictionary:
    return map(map(map(map(map(map(map(map(map(map(map(merge(
        state, {"tick": state.tick + 1, "delta": delta, "world": world}),
        funcref(SimulateFunctions, "simulate_ships")),
        funcref(BulletFunctions, "shoot_bullets")),
        funcref(PhysicsFunctions, "simulate")),
        funcref(WrapFunctions, "wrap")),
        funcref(SoundFunctions, "play_collision_sound")), # Side-effect
        funcref(BulletFunctions, "delete_on_collide")),
        funcref(BulletFunctions, "delete_on_timer")),
        funcref(BulletFunctions, "spawn_bullet_particles_on_destroy")), # Side-effect
        funcref(NodeFunctions, "queue_free")), # Side-effect
        funcref(ObjectFunctions, "queue_free")),
        funcref(NodeFunctions, "update_display")) # Side-effect

static func list_map(list, func_ref): return ListFunctions.map(list, func_ref)
static func list_reduce(list, func_ref, new_state): return ListFunctions.reduce(list, func_ref, new_state)
static func map(state, func_ref): return DictionaryFunctions.map(state, func_ref)
static func merge(destination, source): return DictionaryFunctions.merge(destination, source)
static func update(dict, key, value): return DictionaryFunctions.update(dict, key, value)
