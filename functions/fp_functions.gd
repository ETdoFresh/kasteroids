class_name FPFunctions

static func is_ship_record(record: Record):
    return record is ShipRecord

static func apply_input_on_ship_record(ship: ShipRecord):
    return ship.with("input", ship.node.get_new_input_record())

static func input_to_velocity(ship: ShipRecord):
    var input = ship.input
    var angular_velocity = ship.spin.value * input.horizontal
    var acceleration = Vector2(0, ship.speed.value * input.vertical)
    acceleration = acceleration.rotated(ship.rotation.value)
    return ship \
        .with("angular_velocity", ship.angular_velocity.init(angular_velocity)) \
        .with("linear_acceleration", ship.linear_acceleration.init(acceleration))

static func has_angular_velocity(record: Record):
    return "angular_velocity" in record \
        and record.angular_velocity.value != 0

static func apply_angular_velocity(delta: float, record: Record):
    var rotation = record.rotation.value
    var angular_velocity = record.angular_velocity.value
    return record.with("rotation",
        record.rotation.init(rotation + angular_velocity * delta))

static func update_node(record: Record):
    record.node.record = record

static func can_apply_linear_acceleration(record: Record):
    return "linear_acceleration" in record and "linear_velocity" in record

static func apply_linear_acceleration(delta: float, record: Record):
    var acceleration = record.linear_acceleration.vector2
    var velocity = record.linear_velocity.vector2
    return record.with("linear_velocity", record.linear_velocity.init(
        velocity + acceleration *  delta))

static func can_apply_linear_velocity(record: Record):
    return "linear_velocity" in record and "position" in record

static func apply_linear_velocity(delta: float, record: Record):
    var velocity = record.linear_velocity.vector2
    var position = record.position.vector2
    return record.with("position", record.position.init(
        position + velocity *  delta))

static func has_position(record: Record):
    return "position" in record

static func wrap(record: Record):
    var position = record.position.vector2
    while(position.x < 0): position.x += 1920
    while(position.x >= 1920): position.x -= 1920
    while(position.y < 0): position.y += 1080
    while(position.y >= 1080): position.y -= 1080
    return record.with("position", record.position.init(position))
