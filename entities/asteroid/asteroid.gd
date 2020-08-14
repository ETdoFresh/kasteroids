class_name Asteroid
extends "res://entities/rigid_body_2d/rigid_body_2d.gd"

export var min_angular_velocity = -3.0
export var max_angular_velocity = 3.0
export var min_linear_velocity = 20.0
export var max_linear_velocity = 100.0
export var min_scale = 0.75
export var max_scale = 1.0

var random = RandomNumberGenerator.new()
var id = -1

func _ready():
    random.randomize()
    randomize_spin()
    randomize_speed()
    randomize_scale()

func _integrate_forces(state):
    ._integrate_forces(state)
    $Wrap.wrap(state)

func randomize_spin():
    angular_velocity = random.randf_range(min_angular_velocity, max_angular_velocity)

func randomize_speed():
    var random_direction = Vector2(1,0).rotated(random.randf() * 2 * PI)
    linear_velocity = random_direction
    linear_velocity *= random.randf_range(min_linear_velocity, max_linear_velocity)

func randomize_scale():
    $CollisionShape2D.scale *= random.randf_range(min_scale, max_scale)

var snapping_distance = 100
func linear_interpolate(other, t):
    if (position - other.position).length() > snapping_distance:
        queue_position(other.position)
    else:
        queue_position(position.linear_interpolate(other.position, t))
    queue_rotation(lerp_angle(rotation, other.rotation, t))
    queue_scale($CollisionShape2D.scale.linear_interpolate(other.scale, t))

func to_dictionary():
    return {
        "id": id,
        "type": "Asteroid",
        "position": global_position,
        "rotation": global_rotation,
        "scale": $CollisionShape2D.scale,
        "linear_velocity": linear_velocity,
        "angular_velocity": angular_velocity }
