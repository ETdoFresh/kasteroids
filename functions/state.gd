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

static func initial_state(children: Array) -> Dictionary:
    var result = children
    result = map(result, NodeFunc.to_dictionary)
    result = reduce(result, ObjectFunc.assign_id, empty_state())
    result = exec_on(result, "objects", Asteroid.randomize_asteroids)
    result = exec_on(result, "objects", NodeFunc.update_sprite_scale) # Side-effect)
    return result

static func simulate(state: Dictionary, delta: float, world: Node) -> Dictionary:
    var result = state
    result = merge(result, {"tick": state.tick + 1, "delta": delta, "world": world})
    result = exec_on(result, "objects", Ship.simulate_ships, delta)
    result = add_bullets(result, world) # Side-effect
    result = exec_on(result, "objects", Ship.simulate_ship_fire)
    result = exec_on(result, "objects", Physics.simulate, delta)
    result = map_on(result, "objects", Wrap.wrap)
    result = map_on(result, "objects", Sound.play_collision_sound) # Side-effect
    result = map_on(result, "objects", Bullet.delete_on_collide)
    result = map_on(result, "objects", Bullet.delete_on_timer, delta)
    result = map_on(result, "objects", Bullet.spawn_bullet_particles_on_destroy, world)
    result = map_on(result, "objects", NodeFunc.queue_delete) # Side-effect
    result = delete_objects(result)
    result = exec_on(result, "objects", NodeFunc.update_sprite_scale) # Side-effect
    return result

static func add_bullets(state, world) -> Dictionary:
    var result = reduce(
        Bullet._shoot_bullets(state.objects, world),
        ObjectFunc.assign_id,
        update(state, "objects", {}))
    result = merge(result, state)
    return result

static func delete_objects(state) -> Dictionary:
    var result = reduce(
        filter(state.objects, NodeFunc.is_queue_delete).keys(),
        ObjectFunc.erase_objects,
        state)
    return result
