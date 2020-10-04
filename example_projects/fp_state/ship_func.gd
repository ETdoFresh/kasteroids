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
        world.draw_rect(obj.bounding_box, Color.beige, false, 2.0, true)
    return obj

static func delete_object(obj, objects):
    if obj.queue_delete:
        objects.erase(obj)
        obj.queue_free()
    return objects

static func fix_penetration(obj):
    if obj.collision:
        var other = obj.collision.other
        var pa = obj.collision.position
        var pb = obj.collision.other_position
        var ra = obj.bounding_box.size / 2
        var rb = other.bounding_box.size / 2
        var new_va = obj.linear_velocity
        var new_vb = other.linear_velocity
        var n = obj.collision.normal
        var cr = obj.bounce
        var ppa = pa - n * ra # Penetration Point A
        var ppb = pb + n * rb # Penetration Point B
        var penetration = (ppa - ppb).length()
        var ratio = new_va.length() / (new_va + new_vb).length()
        obj.global_position += n * penetration * ratio
    return obj

static func is_id_unassigned(obj):
    return obj.id == -1

static func is_firing(ship):
    return ship.input.fire and ship.cooldown_timer <= 0

static func limit_velocity(ship):
    if ship.linear_velocity.length() > ship.max_linear_velocity:
        ship.linear_velocity = ship.linear_velocity.normalized()
        ship.linear_velocity *= ship.max_linear_velocity
    return ship

static func play_sound(sound_node: AudioStreamPlayer, world):
    var sound = sound_node.duplicate()
    var length = sound_node.stream.get_length()
    var destroy_timer = Timer.new()
    destroy_timer.connect("timeout", sound, "queue_free")
    destroy_timer.wait_time = length
    destroy_timer.autostart = true
    sound.add_child(destroy_timer)
    world.add_child(sound)
    sound.play()

static func play_collision_sound(obj, world):
    if obj.collision:
        if Settings.sound_on:
            play_sound(obj.collision_sound, world)
    return obj

static func play_spawn_sound(obj, world):
    if obj.spawn:
        if Settings.sound_on:
            play_sound(obj.spawn_sound, world)
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

static func resolve_collision(obj):
    if obj.collision:
        var ma = obj.collision.mass
        var mb = obj.collision.other_mass
        var va = obj.collision.linear_velocity
        var vb = obj.collision.other_linear_velocity
        var n = obj.collision.normal
        var cr = obj.bounce # Coefficient of Restitution
        if (va - vb).dot(n) > 0: return obj # Don't resolve same direction collisions
        var j = -(1.0 + cr) * (va - vb).dot(n) # Impulse Magnitude
        j /= (1.0/ma + 1.0/mb)
        obj.linear_velocity = va + (j / ma) * n
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
        var size = Vector2.ZERO
        if obj.collision_shape is CollisionShape2D:
            position = obj.collision_shape.global_position
            if obj.collision_shape.shape is RectangleShape2D:
                size = obj.collision_shape.shape.extents * 2
            elif obj.collision_shape.shape is CircleShape2D:
                var radius = obj.collision_shape.shape.radius
                size = Vector2(radius, radius) * 2
            elif obj.collision_shape.shape is ConvexPolygonShape2D:
                for point in obj.collision_shape.shape.points:
                    if size.x < abs(point.x) * 2:
                        size.x = abs(point.x) * 2
                        size.y = abs(point.x) * 2
                    if size.y < abs(point.y) * 2:
                        size.x = abs(point.y) * 2
                        size.y = abs(point.y) * 2
            size *= obj.collision_shape.global_scale
            position -= size / 2
        obj.bounding_box = Rect2(position, size)
    else:
        obj.bounding_box.position = obj.collision_shape.global_position
        obj.bounding_box.position -= obj.bounding_box.size / 2
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
