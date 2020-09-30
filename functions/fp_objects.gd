class_name FPObjects

static func init(objects: ObjectsRecord, array: Array):
    return objects.init(array)

static func from_nodes_to_records(objects: ObjectsRecord):
    var from_node_to_record = funcref(FPFunctions, "from_node_to_record")
    return objects.map(from_node_to_record)

static func assign_ids(objects: ObjectsRecord):
    objects = objects.duplicate()
    for i in range(objects.array.size()):
        if objects.array[i].id.value <= 0:
            objects.array[i] = objects.array[i].duplicate()
            objects.array[i].id = objects.array[i].id.init(objects.next_id)
            objects.next_id += 1
    return objects

static func remove_nulls(objects: ObjectsRecord):
    var is_not_null = funcref(FPFunctions, "is_not_null")
    return objects.filter(is_not_null)

static func randomize_asteroids(objects: ObjectsRecord):
    var is_asteroid = funcref(FPFunctions, "is_asteroid")
    var randomize_asteroid = funcref(FPFunctions, "randomize_asteroid")
    return objects.map_only(is_asteroid, randomize_asteroid)

static func apply_input(objects: ObjectsRecord):
    var ships = funcref(FPFunctions, "is_ship_record")
    var apply_input_on_ship_record = funcref(FPFunctions, "apply_input_on_ship_record")
    var input_to_velocity = funcref(FPFunctions, "input_to_velocity")
    return objects \
        .map_only(ships, apply_input_on_ship_record) \
        .map_only(ships, input_to_velocity)

static func apply_linear_acceleration(objects: ObjectsRecord, delta: float):
    var can_apply_linear_acceleration = funcref(FPFunctions, "can_apply_linear_acceleration")
    var apply_linear_acceleration = funcref(FPFunctions, "apply_linear_acceleration")
    var baker = FPBake.new().init(apply_linear_acceleration, delta)
    var apply_linear_acceleration_delta_bake = baker.get_funcref()
    return objects \
        .map_only(can_apply_linear_acceleration, apply_linear_acceleration_delta_bake)

static func apply_linear_velocity(objects: ObjectsRecord, delta: float):
    var can_apply_linear_velocity = funcref(FPFunctions, "can_apply_linear_velocity")
    var apply_linear_velocity = funcref(FPFunctions, "apply_linear_velocity")
    var baker = FPBake.new().init(apply_linear_velocity, delta)
    var apply_linear_velocity_delta_bake = baker.get_funcref()
    return objects \
        .map_only(can_apply_linear_velocity, apply_linear_velocity_delta_bake)

static func apply_angular_velocity(objects: ObjectsRecord, delta: float):
    var has_angular_velocity = funcref(FPFunctions, "has_angular_velocity")
    var apply_angular_velocity = funcref(FPFunctions, "apply_angular_velocity")
    var baker = FPBake.new().init(apply_angular_velocity, delta)
    var apply_angular_velocity_delta_bake = baker.get_funcref()
    return objects \
        .map_only(has_angular_velocity, apply_angular_velocity_delta_bake)

static func wrap_around_the_screen(objects: ObjectsRecord):
    var has_position = funcref(FPFunctions, "has_position")
    var wrap = funcref(FPFunctions, "wrap")
    return objects.map_only(has_position, wrap)

static func update_nodes(objects: ObjectsRecord, world: Node):
    var update_node = funcref(FPFunctions, "update_node")
    var baker = FPBake.new().init(update_node, world)
    var update_node_world_bake = baker.get_funcref()
    var _side_effect = objects.map(update_node_world_bake)
    return objects

static func limit_velocity(objects: ObjectsRecord):
    var has_max_speed = funcref(FPFunctions, "has_linear_velocity_and_max_speed")
    var cap_max_speed = funcref(FPFunctions, "cap_max_speed")
    return objects.map_only(has_max_speed, cap_max_speed)

static func create_bullets(objects: ObjectsRecord):
    var is_ship_firing = funcref(FPFunctions, "is_ship_firing")
    var create_bullet = funcref(FPFunctions, "create_bullet_record")
    return objects.concat( objects \
        .filter(is_ship_firing) \
        .map(create_bullet))

static func set_cooldowns(objects: ObjectsRecord, delta: float):
    var is_ship = funcref(FPFunctions, "is_ship_record")
    var is_ship_firing = funcref(FPFunctions, "is_ship_firing")
    var update_cooldown_timer = funcref(FPFunctions, "update_cooldown_timer")
    var baker = FPBake.new().init(update_cooldown_timer, delta)
    var update_cooldown_timer_delta_bake = baker.get_funcref()
    var reset_cooldown = funcref(FPFunctions, "reset_cooldown")
    return objects \
        .map_only(is_ship_firing, reset_cooldown) \
        .map_only(is_ship, update_cooldown_timer_delta_bake)

static func update_destroy_timers(objects: ObjectsRecord, delta: float):
    var has_destroy_timer = funcref(FPFunctions, "has_destroy_timer")
    var update_destroy_timer = funcref(FPFunctions, "update_destroy_timer")
    var baker = FPBake.new().init(update_destroy_timer, delta)
    var update_destroy_timer_delta_bake = baker.get_funcref()
    return objects.map_only(has_destroy_timer, update_destroy_timer_delta_bake)

static func queue_delete_on_timeout(objects: ObjectsRecord):
    var is_destroy_timer_finished = funcref(FPFunctions, "is_destroy_timer_finished")
    var queue_delete = funcref(FPFunctions, "queue_delete")
    return objects.map_only(is_destroy_timer_finished, queue_delete)

static func delete_objects(objects: ObjectsRecord):
    var is_queue_delete = funcref(FPFunctions, "is_queue_delete")
    var not_is_queue_delete = funcref(FPFunctions, "not_is_queue_delete")
    var node_queue_free = funcref(FPFunctions, "node_queue_free")
    return objects \
        .map_only(is_queue_delete, node_queue_free) \
        .filter(not_is_queue_delete)

static func spawn_bullet_particles_on_bullet_destroy(objects: ObjectsRecord, world: Node2D):
    var is_bullet_destroyed = funcref(FPFunctions, "is_bullet_destroyed")
    var spawn_bullet_particles = funcref(FPFunctions, "spawn_bullet_particles")
    var baker = FPBake.new().init(spawn_bullet_particles, world)
    var spawn_bullet_particles_world_bake = baker.get_funcref()
    var _side_effect = objects.filter(is_bullet_destroyed).map(spawn_bullet_particles_world_bake)
    return objects

static func update_bounding_boxes(objects: ObjectsRecord):
    var has_bounding_box = funcref(FPFunctions, "has_bounding_box")
    var update_bounding_box = funcref(FPFunctions, "update_bounding_box")
    return objects \
        .map_only(has_bounding_box, update_bounding_box)

static func add_new_collisions(objects: ObjectsRecord):
    var can_collide = funcref(FPCollisions, "can_collide")
    var broad_phase_search = funcref(FPCollisions, "broad_phase_search")
    var narrow_phase_search = funcref(FPCollisions, "narrow_phase_search")
    var add_collision_info = funcref(FPCollisions, "add_collision_info")
    var pairs = create_collision_pairs(objects) \
        .filter(can_collide) \
        .filter(broad_phase_search) \
        .filter(narrow_phase_search) \
        .map(add_collision_info)
    var write_first_detected_collision = funcref(FPCollisions, "write_first_detected_collision")
    var baker = FPBake.new().init(write_first_detected_collision, pairs)
    var write_first_detected_collision_bake_pairs = baker.get_funcref()
    return objects.map(write_first_detected_collision_bake_pairs)

static func create_collision_pairs(objects: ObjectsRecord):
    var collision_pair_array = []
    for pair in objects.pairs().array:
        if pair[0].collision_exceptions.find_or_null(pair[1].id.value): continue
        if pair[1].collision_exceptions.find_or_null(pair[0].id.value): continue
        var collision_pair = CollisionPairRecord.new().init(pair[0], pair[1])
        collision_pair_array.append(collision_pair)
    return CollisionPairsRecord.new().init(collision_pair_array)

static func resolve_collisions(objects: ObjectsRecord):
    # TODO: Implement functions below
    var has_collided = funcref(FPCollisions, "has_collided")
    var bounce = funcref(FPCollisions, "bounce")
    return objects.map_only(has_collided, bounce)

static func queue_delete_bullet_on_collide(objects: ObjectsRecord):
    # TODO: Implement functions below
    var has_bullet_collided = funcref(FPFunctions, "has_bullet_collided")
    var queue_delete = funcref(FPFunctions, "queue_delete")
    return objects.map_only(has_bullet_collided, queue_delete)

static func create_bounding_boxes(objects: ObjectsRecord):
    var has_bounding_box = funcref(FPFunctions, "has_bounding_box")
    var create_bounding_box = funcref(FPFunctions, "create_bounding_box")
    return objects.map_only(has_bounding_box, create_bounding_box)
