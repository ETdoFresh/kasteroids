extends Node

const type = "Ship"

export var speed = 800
export var spin = 10
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0
export var mass = 1.0
export var bounce_coeff = 0.7

var id = -1

onready var collision_shapes_2d = []
onready var input = $Input
onready var sprite = $Sprite
onready var gun = $Gun

func _ready():
    for child in get_children():
        if child is CollisionShape2D:
            collision_shapes_2d.append(child)
