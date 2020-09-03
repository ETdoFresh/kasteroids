extends Node

export var engine_thrust = 500
export var spin_thrust = 10

onready var parent = get_parent()

func simulate(delta, input, physics):
    var thrust = Vector2(0, input.vertical * engine_thrust)
    var linear_acceleration = thrust.rotated(parent.global_rotation)
    physics.linear_velocity += linear_acceleration * delta
    
    var rotation_dir = input.horizontal
    physics.angular_velocity = rotation_dir * spin_thrust * delta
    parent.global_rotation += physics.angular_velocity
