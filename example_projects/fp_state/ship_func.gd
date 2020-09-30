static func apply_input(ship):
    var thrust = ship.input.vertical * ship.speed
    ship.angular_velocity = ship.input.horizontal * ship.spin
    ship.linear_acceleration = Vector2(0, thrust).rotated(ship.rotation)
    return ship

static func limit_velocity(ship):
    if ship.linear_velocity.length() > ship.max_linear_velocity:
        ship.linear_velocity = ship.linear_velocity.normalized()
        ship.linear_velocity *= ship.max_linear_velocity
    return ship

static func apply_angular_velocity(ship, delta: float):
    ship.rotation += ship.angular_velocity * delta
    return ship

static func apply_linear_acceleration(ship, delta: float):
    ship.linear_velocity += ship.linear_acceleration * delta
    return ship

static func apply_linear_velocity(ship, delta: float):
    ship.position += ship.linear_velocity * delta
    return ship

static func wrap(ship):
    var position = ship.global_position
    while position.x < 0: position.x += 1280
    while position.x > 1280: position.x -= 1280
    while position.y < 0: position.y += 720
    while position.y > 720: position.y -= 720
    ship.global_position = position
    return ship

static func is_firing(ship):
    return ship.input.fire and ship.cooldown_timer <= 0

static func create_bullet(ship, objects, world):
    if is_firing(ship):
        var bullet = ship.BULLET.instance()
        world.add_child(bullet)
        bullet.global_position = ship.gun.global_position
        bullet.global_rotation = ship.gun.global_rotation
        bullet.linear_velocity = Vector2(0, -bullet.speed).rotated(ship.gun.global_rotation)
        objects.append(bullet)
