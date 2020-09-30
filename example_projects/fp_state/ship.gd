extends KinematicBody2D

const BULLET = preload("res://example_projects/fp_state/bullet.tscn")
const FUNC = preload("res://example_projects/fp_state/ship_func.gd")

# ID
var id = -1

#Ship
var speed = 800.0
var spin = 10.0

# Transform
#var global_position
#var global_rotation
#var global_scale

# Physics Body
export var mass = 1.0
export var bounce_coeff = 0.0
var linear_acceleration = Vector2.ZERO
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

# Physics Options
export var resolve_angular_velocity = true
export var max_linear_velocity = 800.0
export var max_angular_velocity = 3.0

# Physics Collision
var collision_exceptions = []
var collision: CollisionObject

# Gun
var gun_position: Vector2
var gun_rotation: float
var cooldown = 0.2
var cooldown_timer: float

var world = null
var username = "Ship"
var queue_delete = false

onready var input = $Input
onready var gun = $Gun

# Functions
var assign_id = funcref(FUNC, "assign_id")
var apply_input = funcref(FUNC, "apply_input")
var limit_velocity = funcref(FUNC, "limit_velocity")
var apply_angular_velocity = funcref(FUNC, "apply_angular_velocity")
var apply_linear_acceleration = funcref(FUNC, "apply_linear_acceleration")
var apply_linear_velocity = funcref(FUNC, "apply_linear_velocity")
var wrap = funcref(FUNC, "wrap")
var create_bullet = funcref(FUNC, "create_bullet")
var set_cooldown = funcref(FUNC, "set_cooldown")
