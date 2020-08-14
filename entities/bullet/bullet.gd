class_name Bullet
extends "res://entities/rigid_body_2d/rigid_body_2d.gd"

var id = -1

onready var data = $Data

func _ready():
    #warning-ignore:return_value_discarded
    connect("body_entered", self, "_on_self_body_entered")

func start(position, rotation, rigidbody, velocity_magnitude):
    global_position = position
    global_rotation = rotation
    add_collision_exception_with(rigidbody)
    
    var ship_velocity = rigidbody.linear_velocity
    linear_velocity = ship_velocity + Vector2(0, -velocity_magnitude).rotated(rotation)

func _physics_process(_delta):
    data.position = position
    data.rotation = rotation
    data.scale = $CollisionShape2D.scale
    data.linear_velocity = linear_velocity
    data.angular_velocity = angular_velocity

func _integrate_forces(state):
    ._integrate_forces(state)
    $Wrap.wrap(state)

func _on_DestroyAfter_timeout():
    destroy()

func _on_self_body_entered(_body):
    destroy()

func destroy():
    var bullet_particles = Scene.BULLET_PARTICLES.instance()
    var container = get_parent()
    var world = container.get_parent()
    world.add_child(bullet_particles)
    bullet_particles.position = global_position
    bullet_particles.emitting = true
    queue_free()

var snapping_distance = 200
func linear_interpolate(other, t):
    if (position - other.position).length() > snapping_distance:
        queue_position(other.position)
    else:
        queue_position(position.linear_interpolate(other.position, t))
    queue_rotation(lerp_angle(rotation, other.rotation, t))

func to_dictionary():
    return {
        "id": id,
        "type": "Bullet",
        "position": global_position,
        "rotation": global_rotation,
        "scale": $CollisionShape2D.scale,
        "linear_velocity": linear_velocity,
        "angular_velocity": angular_velocity }
