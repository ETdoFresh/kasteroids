static func apply_angular_velocity(ship, delta: float):
    ship.rotation += ship.angular_velocity * delta
    return ship

static func assign_id(obj, state):
    if is_id_unassigned(obj):
        var i = state.objects.find(obj)
        state.objects[i].id = state.next_id
        state.next_id += 1
    return state

static func apply_input(ship):
    var thrust = ship.input.vertical * ship.speed
    ship.angular_velocity = ship.input.horizontal * ship.spin
    ship.linear_acceleration = Vector2(0, thrust).rotated(ship.rotation)
    return ship

static func apply_linear_acceleration(ship, delta: float):
    ship.linear_velocity += ship.linear_acceleration * delta
    return ship

static func apply_linear_velocity(ship, delta: float):
    ship.position += ship.linear_velocity * delta
    return ship

static func broad_phase_collision_detection(obj, objects):
    for i in range(objects.size()):
        if obj == objects[i]:
            continue
        if not "broad_phase_collision_detection" in objects[i]:
            continue
        if obj.collision_exceptions.has(objects[i]):
            continue
        if objects[i].collision_exceptions.has(obj):
            continue
        var is_overlapping = obj.bounding_box.intersects(objects[i].bounding_box)
        if is_overlapping:
            obj.broadphase_collision = true
            break
    return obj

static func narrow_phase_collision_detection(obj, objects):
    if not obj.broadphase_collision:
        return obj
    for i in range(objects.size()):
        var other = objects[i]
        if obj == other:
            continue
        if not "broad_phase_collision_detection" in other:
            continue
        if not obj.broadphase_collision:
            continue
        var local_transform = obj.transform
        var other_shape = other.collision_shape.shape
        var other_transform = other.transform
        var contacts = obj.collision_shape.shape.collide_and_get_contacts(local_transform, other_shape, other_transform)
        if contacts.size() > 0:
            var average_contact = Vector2.ZERO
            for contact in contacts: average_contact += contact
            average_contact /= contacts.size()
            obj.collision = Collision.new().init(obj, other, average_contact)
            break
    return obj

static func clear_collision(obj):
    obj.broadphase_collision = false
    obj.collision = null
    return obj

static func clear_spawn(obj):
    obj.spawn = false
    return obj

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
        bullet.spawn = true
        objects.append(bullet)
    return objects

static func draw_debug_bounding_box(obj, world):
    if obj.bounding_box:
        var position = obj.bounding_box.position - obj.bounding_box.extents
        var size = obj.bounding_box.extents * 2
        var rect = Rect2(position, size)
        world.draw_rect(rect, Color.beige, false, 2.0, true)
    return obj

static func delete_object(obj, objects):
    if obj.queue_delete:
        objects.erase(obj)
        obj.queue_free()
    return objects

static func is_id_unassigned(obj):
    return obj.id == -1

static func is_firing(ship):
    return ship.input.fire and ship.cooldown_timer <= 0

static func limit_velocity(ship):
    if ship.linear_velocity.length() > ship.max_linear_velocity:
        ship.linear_velocity = ship.linear_velocity.normalized()
        ship.linear_velocity *= ship.max_linear_velocity
    return ship

static func play_spawn_sound(obj):
    if obj.spawn:
        if Settings.sound_on:
            obj.spawn_sound.play()
    return obj

static func queue_delete_bullet_on_timeout(obj):
    if obj.destroy_timer <= 0:
        obj.queue_delete = true
    return obj

static func queue_delete_bullet_on_collide(obj):
    if obj.collision:
        obj.queue_delete = true
    return obj

static func randomize_linear_velocity(obj):
    var min_range = obj.random_linear_velocity.x
    var max_range = obj.random_linear_velocity.y
    var random_value = Random.randf_range(min_range, max_range)
    obj.linear_velocity = Random.on_unit_circle() * random_value
    return obj

static func randomize_angular_velocity(obj):
    var min_range = obj.random_angular_velocity.x
    var max_range = obj.random_angular_velocity.y
    obj.angular_velocity = Random.randf_range(min_range, max_range)
    return obj

static func randomize_scale(obj):
    var min_range = obj.random_scale.x
    var max_range = obj.random_scale.y
    obj.global_scale *= Random.randf_range(min_range, max_range)
    return obj

static func set_cooldown(ship, delta):
    if is_firing(ship):
        ship.cooldown_timer = ship.cooldown
    elif ship.cooldown_timer > 0:
        ship.cooldown_timer -= delta
    return ship

static func spawn_bullet_particles_on_delete(bullet, world):
    if bullet.queue_delete:
        var particles = bullet.PARTICLES.instance()
        world.add_child(particles)
        particles.global_position = bullet.global_position
        particles.emitting = true
    return bullet

static func update_bounding_box(obj):
    if not obj.bounding_box:
        var position = Vector2.ZERO
        var extents = Vector2.ZERO
        if obj.collision_shape is CollisionShape2D:
            position = obj.collision_shape.global_position
            if obj.collision_shape.shape is RectangleShape2D:
                extents = obj.collision_shape.shape.extents
            elif obj.collision_shape.shape is CircleShape2D:
                var radius = obj.collision_shape.shape.radius
                extents = Vector2(radius, radius)
            elif obj.collision_shape.shape is ConvexPolygonShape2D:
                for point in obj.collision_shape.shape.points:
                    if extents.x < abs(point.x):
                        extents.x = abs(point.x)
                        extents.y = abs(point.x)
                    if extents.y < abs(point.y):
                        extents.x = abs(point.y)
                        extents.y = abs(point.y)
            extents *= obj.collision_shape.global_scale
        obj.bounding_box = BoundingBox.new(position, extents)
    else:
        obj.bounding_box.position = obj.collision_shape.global_position
    return obj

static func update_destroy_timer(obj, delta):
    if obj.destroy_timer > 0:
        obj.destroy_timer -= delta
    return obj

static func wrap(ship):
    var position = ship.global_position
    while position.x < 0: position.x += 1280
    while position.x > 1280: position.x -= 1280
    while position.y < 0: position.y += 720
    while position.y > 720: position.y -= 720
    ship.global_position = position
    return ship
