class_name PhysicsFunctions

const COLLISION = CollisionFunctions
const ID = IdFunctions
const LIST = ListFunctions
const PHYSICS_NODES = PhysicsNodesFunctions

static func simulate(objects: Array, delta: float) -> Array:
    objects = objects.duplicate()
    objects = LIST.map(objects, funcref(PHYSICS_NODES, "setup_physical_bodies")) # Side-effect
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "move_and_collide"), delta) # Both
    objects = LIST.map(objects, funcref(PHYSICS_NODES, "update_objects_from_physical_bodies"))
    var _collisions = LIST.filter(objects, funcref(COLLISION, "has_collision"))
    # TODO: Handle Collisions
    # TODO: Collide Event on Object?
    return objects

static func add_collisions_to_other_colliders(objects: Array) -> Array:
    objects = objects.duplicate()
    for i in range(objects.size()):
        if not "node" in objects[i]: continue
        for other_object in objects:
            if "collisions" in other_object:
                for collision in other_object.collisions:
                    if collision.other == objects[i]:
                        objects[i] = objects[i].duplicate()
                        objects[i].collisions.append({
                            "other": other_object.id,
                            "normal": -collision.normal,
                            "position": collision.position,
                            "remainder": 0.0})
    return objects

static func has_collided(object: Dictionary) -> bool:
    return "collisions" in object and object.collisions.size() > 0

static func resolve_collisions(objects: Array) -> Array:
    objects = objects.duplicate()
    for i in range(objects.size()):
        if not "collisions" in objects[i]: continue
        if objects[i].collisions.size() == 0: continue
        for collision in objects[i].collisions:
            objects[i] = bounce_no_angular_velocity(objects[i], collision)
        objects[i].collisions.clear()
    return objects

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

static func bounce_no_angular_velocity(object, collision):
    var other = collision.other
    var ma = object.mass
    var mb = other.mass
    var va = object.linear_velocity
    var vb = other.linear_velocity
    var n = collision.normal
    var cr = object.bounce_coeff # Coefficient of Restitution
    var j = -(1.0 + cr) * (va - vb).dot(n) # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb)
    object.linear_velocity = va + (j / ma) * n
    return object

static func cross_vf(v : Vector2, f : float):
    return Vector2(f * v.y, -f * v.x)

static func cross_fv(f : float, v : Vector2):
    return Vector2(-f * v.y, f * v.x)

static func cross(a : Vector2, b : Vector2):
    return a.x * b.y - a.y * b.x;
