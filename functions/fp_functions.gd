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

static func update_node(world: Node2D, record: Record):
    if not record.node.is_inside_tree():
        world.add_child(record.node)
    record.node.set_record(record)

static func can_apply_linear_acceleration(record: Record):
    return "linear_acceleration" in record and "linear_velocity" in record

static func apply_linear_acceleration(delta: float, record: Record):
    var acceleration = record.linear_acceleration.value
    var velocity = record.linear_velocity.value
    return record.with("linear_velocity", record.linear_velocity.init(
        velocity + acceleration *  delta))

static func can_apply_linear_velocity(record: Record):
    return "linear_velocity" in record and "position" in record

static func apply_linear_velocity(delta: float, record: Record):
    var velocity = record.linear_velocity.value
    var position = record.position.value
    return record.with("position", record.position.init(
        position + velocity *  delta))

static func has_position(record: Record):
    return "position" in record

static func wrap(record: Record):
    var position = record.position.value
    while(position.x < 0): position.x += 1920
    while(position.x >= 1920): position.x -= 1920
    while(position.y < 0): position.y += 1080
    while(position.y >= 1080): position.y -= 1080
    return record.with("position", record.position.init(position))

static func in1(string: String, record: Record):
    return string in record

static func in2(string1: String, string2: String, record: Record):
    return string1 in record and string2 in record

static func in3(string1: String, string2: String, string3: String, record: Record):
    return string1 in record and string2 in record and string3 in record

static func is1(record:Record, type):
    return record is type

static func is2(record:Record, type1, type2):
    return record is type1 and record is type2

static func is3(record:Record, type1, type2, type3):
    return record is type1 and record is type2 and record is type3

static func has_linear_velocity_and_max_speed(record: Record):
    return in2("linear_velocity", "max_speed", record)

static func cap_max_speed(record: Record):
    var max_speed = record.max_speed.value
    var velocity = record.linear_velocity.value
    if velocity.length() > max_speed:
        velocity = velocity.normalized() * max_speed
        velocity = record.linear_velocity.init(velocity)
        return record.with("linear_velocity", velocity)
    else:
        return record

static func is_ship_firing(shipRecord: ShipRecord):
    return shipRecord.cooldown_timer.value == 0 and \
        shipRecord.input.fire

static func create_bullet_record(shipRecord: ShipRecord):
    var ship_position = shipRecord.position.value
    var ship_rotation = shipRecord.rotation.value
    var ship_velocity = shipRecord.linear_velocity.value
    var gun_position = shipRecord.gun_position.value
    gun_position *= shipRecord.scale.value.x
    gun_position = ship_position + gun_position.rotated(ship_rotation)
    var gun_rotation = shipRecord.gun_rotation.value
    gun_rotation = ship_rotation + gun_rotation
    var bullet = Scene.BULLET_SCENE.instance()
    var bullet_velocity = Vector2(0, -bullet.speed).rotated(gun_rotation)
    bullet_velocity += ship_velocity
    var bullet_record = bullet.get_record()
    bullet_record.position = bullet_record.position.init(gun_position)
    bullet_record.rotation = bullet_record.rotation.init(gun_rotation)
    bullet_record.linear_velocity = bullet_record.linear_velocity.init(bullet_velocity)
    return bullet_record

static func update_cooldown_timer(delta: float, shipRecord: ShipRecord):
    var cooldown_timer = shipRecord.cooldown_timer.value
    if cooldown_timer > 0:
        cooldown_timer -= delta
        cooldown_timer = shipRecord.cooldown_timer.init(cooldown_timer)
        return shipRecord.with("cooldown_timer", cooldown_timer)
    else:
        return shipRecord

static func reset_cooldown(shipRecord: ShipRecord):
    var new_cooldown_timer = shipRecord.cooldown.value
    new_cooldown_timer = shipRecord.cooldown_timer.init(new_cooldown_timer)
    return shipRecord.with("cooldown_timer", new_cooldown_timer)

static func has_destroy_timer(record: Record):
    return "destroy_timer" in record

static func update_destroy_timer(delta: float, record: Record):
    var new_destroy_timer = record.destroy_timer.value
    new_destroy_timer -= delta
    new_destroy_timer = record.destroy_timer.init(new_destroy_timer)
    return record.with("destroy_timer", new_destroy_timer)
