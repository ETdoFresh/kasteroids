class_name ShipFunctions

static func is_ship(object : Dictionary) -> bool:
    return "type" in object and object.type == "Ship"

static func apply_input(ship : Dictionary, delta: float) -> Dictionary:
    ship = ship.duplicate()
    var thrust = Vector2(0, ship.input.vertical * ship.speed)
    var linear_acceleration = thrust.rotated(ship.rotation)
    ship.linear_velocity += linear_acceleration * delta
    
    var rotation_dir = ship.input.horizontal
    ship.angular_velocity = rotation_dir * ship.spin * delta
    return ship

static func limit_speed(ship : Dictionary) -> Dictionary:
    ship = ship.duplicate()
    if ship.linear_velocity.length() > ship.speed:
        ship.linear_velocity = ship.linear_velocity.normalized() * ship.speed
    return ship
