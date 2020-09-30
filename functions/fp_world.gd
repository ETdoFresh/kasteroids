class_name FPWorld

func new_state(): 
    return StateRecord.new().init(0, ObjectsRecord.new().init([]))

func ready(world: Node):
    var state = new_state()
    state.objects = FPObjects.init(state.objects, world.get_children())
    state.objects = FPObjects.from_nodes_to_records(state.objects)
    state.objects = FPObjects.remove_nulls(state.objects)
    state.objects = FPObjects.assign_ids(state.objects)
    state.objects = FPObjects.randomize_asteroids(state.objects)
    return state

func process(state: StateRecord, delta: float, world: Node):
    state = state.duplicate()
    state.tick += 1
    state.objects = FPObjects.apply_input(state.objects)
    state.objects = FPObjects.create_bullets(state.objects)
    state.objects = FPObjects.assign_ids(state.objects)
    state.objects = FPObjects.set_cooldowns(state.objects, delta)
    state.objects = FPObjects.limit_velocity(state.objects)
    state.objects = FPObjects.apply_angular_velocity(state.objects, delta)
    state.objects = FPObjects.apply_linear_acceleration(state.objects, delta)
    state.objects = FPObjects.apply_linear_velocity(state.objects, delta)
    state.objects = FPObjects.wrap_around_the_screen(state.objects)
    state.objects = FPObjects.update_bounding_boxes(state.objects)
    state.objects = FPObjects.add_new_collisions(state.objects)
    state.objects = FPObjects.resolve_collisions(state.objects)
    state.objects = FPObjects.update_destroy_timers(state.objects, delta)
    state.objects = FPObjects.queue_delete_bullet_on_collide(state.objects)
    state.objects = FPObjects.queue_delete_on_timeout(state.objects)
    state.objects = FPObjects.spawn_bullet_particles_on_bullet_destroy(state.objects, world)
    state.objects = FPObjects.delete_objects(state.objects)
    state.objects = FPObjects.update_nodes(state.objects, world)
    return state
