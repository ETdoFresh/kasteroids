class_name AsteroidFunctions

static func is_asteroid(_id: int, object: Dictionary) -> bool:
    return "type" in object and object.type == "Asteroid"

static func randomize_angular_velocity(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_angular_velocity: return asteroid
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_angular_velocity
    var max_vel = asteroid.max_angular_velocity
    asteroid.angular_velocity = Random.randf_range(min_vel, max_vel)
    return asteroid

static func randomize_linear_velocity(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_linear_velocity: return asteroid
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_linear_velocity
    var max_vel = asteroid.max_linear_velocity
    asteroid.linear_velocity = Random.on_unit_circle()
    asteroid.linear_velocity *= Random.randf_range(min_vel, max_vel)
    return asteroid

static func randomize_scale(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_scale: return asteroid
    asteroid = asteroid.duplicate()
    var min_scl = asteroid.min_scale
    var max_scl = asteroid.max_scale
    asteroid.scale *= Random.randf_range(min_scl, max_scl)
    return asteroid
