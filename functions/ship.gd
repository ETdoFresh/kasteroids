class_name ShipFunctions

static func simulate(_key: int, ship: Dictionary, delta: float) -> Dictionary:
    ship = apply_input(ship, delta)
    ship = limit_speed(ship)
    ship = cooldown(ship, delta)
    return ship

static func is_ship(_key: int, object : Dictionary) -> bool:
    return "type" in object and object.type == "Ship"

static func is_ready_to_fire(ship: Dictionary) -> bool:
    return ship.cooldown_timer <= 0

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

static func cooldown(ship: Dictionary, delta: float) -> Dictionary:
    if ship.cooldown_timer > 0:
        ship = ship.duplicate()
        ship.cooldown_timer -= delta
    return ship

static func fire(_key, ship: Dictionary) -> Dictionary:
    if is_ready_to_fire(ship):
        if ship.input.fire:
            ship = ship.duplicate()
            ship.cooldown_timer = ship.cooldown
    return ship
