extends Node

const type = "Ship"

export var speed = 800
export var spin = 10
export var linear_velocity = Vector2.ZERO
export var mass = 1.0
export var bounce_coeff = 0.7

onready var collision_shape_2d = $CollisionShape2D
onready var input = $Input
onready var shape = $CollisionShape2D
onready var sprite = $Sprite
