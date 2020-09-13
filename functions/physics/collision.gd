class_name CollisionFunctions

const COLLISION_MARKER_SCENE = preload("res://scenes/collision_marker/collision_marker.tscn")

static func has_collision(object: Dictionary) -> bool:
    return "collision" in object and object.collision

static func get_collision(object: Dictionary):
    return object.collision

static func clear_collision(object: Dictionary) -> Dictionary:
    object = object.duplicate()
    object["collision"] = null
    return object

static func add_collision_markers(objects: Array, world: Node) -> Array:
    for object in objects:
        if object.collision:
            var collision_marker = COLLISION_MARKER_SCENE.instance()
            collision_marker.position = object.collision.position
            collision_marker.normal = object.collision.normal
            collision_marker.position1 = object.position
            collision_marker.is_other = "is_other" in object.collision
            world.add_child(collision_marker)
    return objects

static func apply_remainder(object: Dictionary) -> Dictionary:
    if not "collision" in object: return object
    if not object.collision: return object
    object = object.duplicate()
    var remainder_length = object.collision.remainder.length()
    var normalized_linear_velocity = object.linear_velocity.normalized()
    object.position += remainder_length * normalized_linear_velocity
    return object

static func bounce(object: Dictionary, collision) -> Dictionary:
    object = object.duplicate()
    var other = collision.other
    var ma = object.mass
    var mb = other.mass
    var va = object.linear_velocity
    var vb = other.linear_velocity
    var n = collision.normal
    var cr = object.bounce_coeff # Coefficient of Restitution
    var wa = object.angular_velocity
    var wb = other.angular_velocity
    var ra = collision.position - object.position
    var rb = collision.position - other.position
    var rv = va + cross_fv(wa, ra) - vb - cross_fv(wb, rb) # Relative Velocity
    rv = va - vb
    var cv = rv.dot(n) # Contact Velocity
    var ia = ma * ra.length_squared() # Rotational Inertia
    var ib = mb * rb.length_squared() # Rotational Inertia
    var iia = 1.0 / ia
    var iib = 1.0 / ib
    var ra_x_n = cross(ra, n)
    var rb_x_n = cross(rb, n)
    var iia_ra_x_n = iia * ra_x_n
    var iib_rb_x_n = iib * rb_x_n
    var angular_denominator = cross_fv(iia_ra_x_n, ra) + cross_fv(iib_rb_x_n, rb)
    angular_denominator = angular_denominator.dot(n)
    var j = -(1.0 + cr) * cv # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb) + angular_denominator
    object.linear_velocity = va + (j / ma) * n
    object.angular_velocity = wa + iia * cross(ra, j * n)
    return object

static func bounce_no_angular_velocity(object: Dictionary):
    if not "collision" in object: return object
    if not object.collision: return object
    var other = object.collision.other
    var ma = object.mass
    var mb = other.mass
    var va = object.linear_velocity
    var vb = other.linear_velocity
    var n = object.collision.normal
    var cr = object.bounce_coeff # Coefficient of Restitution
    var j = -(1.0 + cr) * (va - vb).dot(n) # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb)
    object = object.duplicate()
    object.linear_velocity = va + (j / ma) * n
    return object

static func cross_vf(v : Vector2, f : float):
    return Vector2(f * v.y, -f * v.x)

static func cross_fv(f : float, v : Vector2):
    return Vector2(-f * v.y, f * v.x)

static func cross(a : Vector2, b : Vector2):
    return a.x * b.y - a.y * b.x;
