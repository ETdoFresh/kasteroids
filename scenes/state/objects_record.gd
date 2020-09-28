class_name ObjectsRecord
extends ArrayRecord

func apply_input() -> ObjectsRecord:
    var ships = funcref(FPFunctions, "is_ship_record")
    var apply_input_on_ship_record = funcref(FPFunctions, "apply_input_on_ship_record")
    var input_to_velocity = funcref(FPFunctions, "input_to_velocity")
    return map_only(ships, apply_input_on_ship_record) \
        .map_only(ships, input_to_velocity)

func apply_linear_acceleration(delta: float) -> ObjectsRecord:
    var can_apply_linear_acceleration = funcref(FPFunctions, "can_apply_linear_acceleration")
    var apply_linear_acceleration = funcref(FPFunctions, "apply_linear_acceleration")
    var baker = FPBake.new().init(apply_linear_acceleration, delta)
    var apply_linear_acceleration_delta_bake = baker.get_funcref()
    return map_only(can_apply_linear_acceleration, apply_linear_acceleration_delta_bake)

func apply_linear_velocity(delta: float) -> ObjectsRecord:
    var can_apply_linear_velocity = funcref(FPFunctions, "can_apply_linear_velocity")
    var apply_linear_velocity = funcref(FPFunctions, "apply_linear_velocity")
    var baker = FPBake.new().init(apply_linear_velocity, delta)
    var apply_linear_velocity_delta_bake = baker.get_funcref()
    return map_only(can_apply_linear_velocity, apply_linear_velocity_delta_bake)

func apply_angular_velocity(delta: float) -> ObjectsRecord:
    var has_angular_velocity = funcref(FPFunctions, "has_angular_velocity")
    var apply_angular_velocity = funcref(FPFunctions, "apply_angular_velocity")
    var baker = FPBake.new().init(apply_angular_velocity, delta)
    var apply_angular_velocity_delta_bake = baker.get_funcref()
    return map_only(has_angular_velocity, apply_angular_velocity_delta_bake)

func wrap_around_the_screen() -> ObjectsRecord:
    var has_position = funcref(FPFunctions, "has_position")
    var wrap = funcref(FPFunctions, "wrap")
    return map_only(has_position, wrap)

func update_nodes(world: Node) -> ObjectsRecord:
    var update_node = funcref(FPFunctions, "update_node")
    var baker = FPBake.new().init(update_node, world)
    var update_node_world_bake = baker.get_funcref()
    var _side_effect = map(update_node_world_bake)
    return self

func limit_velocity() -> ObjectsRecord:
    var has_max_speed = funcref(FPFunctions, "has_linear_velocity_and_max_speed")
    var cap_max_speed = funcref(FPFunctions, "cap_max_speed")
    return map_only(has_max_speed, cap_max_speed)

func queue_create_bullets() -> ObjectsRecord:
    var is_ship_firing = funcref(FPFunctions, "is_ship_firing")
    var create_bullet = funcref(FPFunctions, "create_bullet_record")
    return concat( \
        .filter(is_ship_firing) \
        .map(create_bullet))

func set_cooldowns(delta: float) -> ObjectsRecord:
    var is_ship = funcref(FPFunctions, "is_ship_record")
    var is_ship_firing = funcref(FPFunctions, "is_ship_firing")
    var update_cooldown_timer = funcref(FPFunctions, "update_cooldown_timer")
    var baker = FPBake.new().init(update_cooldown_timer, delta)
    var update_cooldown_timer_delta_bake = baker.get_funcref()
    var reset_cooldown = funcref(FPFunctions, "reset_cooldown")
    return self \
        .map_only(is_ship_firing, reset_cooldown) \
        .map_only(is_ship, update_cooldown_timer_delta_bake)

func update_destroy_timers(delta: float) -> ObjectsRecord:
    var has_destroy_timer = funcref(FPFunctions, "has_destroy_timer")
    var update_destroy_timer = funcref(FPFunctions, "update_destroy_timer")
    var baker = FPBake.new().init(update_destroy_timer, delta)
    var update_destroy_timer_delta_bake = baker.get_funcref()
    return map_only(has_destroy_timer, update_destroy_timer_delta_bake)

func queue_delete_on_timeout():
    var is_destroy_timer_finished = funcref(FPFunctions, "is_destroy_timer_finished")
    var queue_delete = funcref(FPFunctions, "queue_delete")
    return map_only(is_destroy_timer_finished, queue_delete)

func delete_objects():
    var is_queue_delete = funcref(FPFunctions, "is_queue_delete")
    var not_is_queue_delete = funcref(FPFunctions, "not_is_queue_delete")
    var node_queue_free = funcref(FPFunctions, "node_queue_free")
    return map_only(is_queue_delete, node_queue_free) \
        .filter(not_is_queue_delete)

func spawn_bullet_particles_on_bullet_destroy(world: Node2D):
    var is_bullet_destroyed = funcref(FPFunctions, "is_bullet_destroyed")
    var spawn_bullet_particles = funcref(FPFunctions, "spawn_bullet_particles")
    var baker = FPBake.new().init(spawn_bullet_particles, world)
    var spawn_bullet_particles_world_bake = baker.get_funcref()
    var _side_effect = filter(is_bullet_destroyed).map(spawn_bullet_particles_world_bake)
    return self

func add_new_collisions():
    # TODO: Implement functions below
    var create_collision_pair_record = funcref(FPFunctions, "create_collision_pair_record")
    var update_bounding_box = funcref(FPFunctions, "update_bounding_box")
    var can_collide = funcref(FPFunctions, "can_collide")
    var broad_phase_search = funcref(FPFunctions, "broad_phase_search")
    var narrow_phase_search = funcref(FPFunctions, "narrow_phase_search")
    var pairs = pairs() \
        .map(create_collision_pair_record) \
        .map_only(can_collide, update_bounding_box) \
        .map_only(can_collide, broad_phase_search) \
        .map_only(can_collide, narrow_phase_search)
    var write_closest_collision = funcref(FPFunctions, "wite_closest_collision")
    var baker = FPBake.new().init(write_closest_collision, pairs)
    var write_closest_collision_pairs_bake = baker.get_funcref()
    return map(write_closest_collision_pairs_bake)

func resolve_collisions():
    # TODO: Implement functions below
    var has_collided = funcref(FPFunctions, "has_collided")
    var bounce = funcref(FPFunctions, "bounce")
    return map_only(has_collided, bounce)

func queue_delete_bullet_on_collide():
    # TODO: Implement functions below
    var has_bullet_collided = funcref(FPFunctions, "has_bullet_collided")
    var queue_delete = funcref(FPFunctions, "queue_delete")
    return map_only(has_bullet_collided, queue_delete)
