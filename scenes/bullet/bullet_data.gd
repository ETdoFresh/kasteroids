extends Node

const type = "Bullet"

export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0
export var mass = 0.15
export var bounce_coeff = 0.2
export var destroy_time = 1

var id = -1
var destroy_timer = 0

onready var collision_shapes_2d = []
onready var spawn_sound = $SpawnSound
#onready var collision_sound = $CollisionSound
onready var sprite = $Sprite

func _ready():
    for child in get_children():
        if child is CollisionShape2D:
            collision_shapes_2d.append(child)
