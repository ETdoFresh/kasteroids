extends Node

export var min_angular_velocity = -3.0
export var max_angular_velocity = 3.0
export var min_linear_velocity = 20.0
export var max_linear_velocity = 100.0
export var min_scale = 0.75
export var max_scale = 1.0

var random = RandomNumberGenerator.new()

func randomize_asteroid(asteroid):
    random.randomize()
    randomize_spin(asteroid)
    randomize_speed(asteroid)
    randomize_scale(asteroid)

func randomize_spin(asteroid):
    asteroid.physics.angular_velocity = random.randf_range(min_angular_velocity, max_angular_velocity)

func randomize_speed(asteroid):
    var random_direction = Vector2(1,0).rotated(random.randf() * 2 * PI)
    asteroid.physics.linear_velocity = random_direction
    asteroid.physics.linear_velocity *= random.randf_range(min_linear_velocity, max_linear_velocity)

func randomize_scale(asteroid):
    asteroid.collision_shape_2d.scale *= random.randf_range(min_scale, max_scale)
