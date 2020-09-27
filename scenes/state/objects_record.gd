class_name ObjectsRecord
extends ArrayRecord

func apply_input():
    var ships = funcref(FPFunctions, "is_ship_record")
    var apply_input_on_ship_record = funcref(FPFunctions, "apply_input_on_ship_record")
    var input_to_velocity = funcref(FPFunctions, "input_to_velocity")
    return map_only(ships, apply_input_on_ship_record) \
        .map_only(ships, input_to_velocity)

func apply_linear_acceleration(delta: float):
    var can_apply_linear_acceleration = funcref(FPFunctions, "can_apply_linear_acceleration")
    var apply_linear_acceleration = funcref(FPFunctions, "apply_linear_acceleration")
    var baker = FPBake.new().init(apply_linear_acceleration, delta)
    var apply_linear_acceleration_delta_bake = baker.get_funcref()
    return map_only(can_apply_linear_acceleration, apply_linear_acceleration_delta_bake)

func apply_linear_velocity(delta: float):
    var can_apply_linear_velocity = funcref(FPFunctions, "can_apply_linear_velocity")
    var apply_linear_velocity = funcref(FPFunctions, "apply_linear_velocity")
    var baker = FPBake.new().init(apply_linear_velocity, delta)
    var apply_linear_velocity_delta_bake = baker.get_funcref()
    return map_only(can_apply_linear_velocity, apply_linear_velocity_delta_bake)

func apply_angular_velocity(delta: float):
    var has_angular_velocity = funcref(FPFunctions, "has_angular_velocity")
    var apply_angular_velocity = funcref(FPFunctions, "apply_angular_velocity")
    var baker = FPBake.new().init(apply_angular_velocity, delta)
    var apply_angular_velocity_delta_bake = baker.get_funcref()
    return map_only(has_angular_velocity, apply_angular_velocity_delta_bake)

func wrap_around_the_screen():
    var has_position = funcref(FPFunctions, "has_position")
    var wrap = funcref(FPFunctions, "wrap")
    return map_only(has_position, wrap)

func update_nodes(world: Node):
    var update_node = funcref(FPFunctions, "update_node")
    var baker = FPBake.new().init(update_node, world)
    var update_node_world_bake = baker.get_funcref()
    var _side_effect = map(update_node_world_bake)
    return self

func limit_velocity():
    var has_max_speed = funcref(FPFunctions, "has_linear_velocity_and_max_speed")
    var cap_max_speed = funcref(FPFunctions, "cap_max_speed")
    return map_only(has_max_speed, cap_max_speed)

func queue_create_bullets():
    var is_ship = funcref(FPFunctions, "is_ship_record")
    var is_ship_firing = funcref(FPFunctions, "is_ship_firing")
    var create_bullet = funcref(FPFunctions, "create_bullet_record")
    return concat( \
        filter(is_ship) \
        .filter(is_ship_firing) \
        .map(create_bullet))
