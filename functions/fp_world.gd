class_name FPWorld

func new_state(): 
    return StateRecord.new().init(0, ObjectsRecord.new().init([]))

func ready(world: Node):
    return new_state() \
        .with("objects", ObjectsRecord.new() \
            .init(world.get_children()) \
            .from_nodes_to_records() \
            .remove_nulls() \
            .assign_ids() \
            .randomize_asteroids())

func process(state: StateRecord, delta: float, world: Node):
    return state \
        .with("tick", state.tick + 1) \
        .with("objects", state.objects \
            .apply_input() \
            .create_bullets() \
            .assign_ids() \
            .set_cooldowns(delta) \
            .limit_velocity() \
            .apply_angular_velocity(delta) \
            .apply_linear_acceleration(delta) \
            .apply_linear_velocity(delta) \
            .wrap_around_the_screen() \
            .update_bounding_boxes() \
            .add_new_collisions() \
            .resolve_collisions() \
            .update_destroy_timers(delta) \
            .queue_delete_bullet_on_collide() \
            .queue_delete_on_timeout() \
            .spawn_bullet_particles_on_bullet_destroy(world) \
            .delete_objects() \
            .update_nodes(world))
