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
        var relative_velocity = ship.linear_velocity
        world.add_child(bullet)
        bullet.global_position = ship.gun.global_position
        bullet.global_rotation = ship.gun.global_rotation
        bullet.linear_velocity = Vector2(0, -bullet.speed).rotated(ship.gun.global_rotation)
        bullet.linear_velocity += relative_velocity
        bullet.collision_exceptions.append(ship)
        objects.append(bullet)
    return objects

static func set_cooldown(ship, delta):
    if is_firing(ship):
        ship.cooldown_timer = ship.cooldown
    elif ship.cooldown_timer > 0:
        ship.cooldown_timer -= delta
    return ship

static func update_destroy_timer(obj, delta):
    if obj.destroy_timer > 0:
        obj.destroy_timer -= delta
    return obj

static func queue_delete_bullet_on_timeout(obj):
    if obj.destroy_timer <= 0:
        obj.queue_delete = true
    return obj

static func delete_object(obj, objects):
    if obj.queue_delete:
        objects.erase(obj)
        obj.queue_free()
    return objects

static func spawn_bullet_particles_on_delete(bullet, world):
    if bullet.queue_delete:
        var particles = bullet.PARTICLES.instance()
        world.add_child(particles)
        particles.global_position = bullet.global_position
        particles.emitting = true
    return bullet

static func is_id_unassigned(obj):
    return obj.id == -1

static func assign_id(obj, state):
    if is_id_unassigned(obj):
        var i = state.objects.find(obj)
        state.objects[i].id = state.next_id
        state.next_id += 1
    return state
