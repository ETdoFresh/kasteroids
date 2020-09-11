class_name AsteroidFunctions

static func is_asteroid(object : Dictionary) -> bool:
    return "type" in object and object.type == "Asteroid"

static func randomize_angular_velocity(asteroid : Dictionary) -> Dictionary:
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_angular_velocity
    var max_vel = asteroid.max_angular_velocity
    asteroid.angular_velocity = Random.randf_range(min_vel, max_vel)
    return asteroid

static func randomize_linear_velocity(asteroid : Dictionary) -> Dictionary:
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_linear_velocity
    var max_vel = asteroid.max_linear_velocity
    asteroid.linear_velocity = Random.on_unit_circle()
    asteroid.linear_velocity *= Random.randf_range(min_vel, max_vel)
    return asteroid

static func randomize_scale(asteroid : Dictionary) -> Dictionary:
    asteroid = asteroid.duplicate()
    var min_scl = asteroid.min_scale
    var max_scl = asteroid.max_scale
    asteroid.scale = Vector2.ONE * Random.randf_range(min_scl, max_scl)
    return asteroid
