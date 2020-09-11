extends Node

const type = "Asteroid"

export var min_angular_velocity = -3.0
export var max_angular_velocity = 3.0
export var min_linear_velocity = 20.0
export var max_linear_velocity = 100.0
export var min_scale = 0.75
export var max_scale = 1.0
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0
export var mass = 5.0
export var bounce_coeff = 0.2

onready var collision_shape_2d = $CollisionShape2D
onready var collision_sound = $CollisionSound
