extends Node2D

# Node
var id = -1
var queue_delete = false

#Ship
onready var input = $Input
var username = "Ship"
var speed = 800.0
var spin = 10.0

# Physics Body
export var mass = 1.0
export var bounce = 0.0
var linear_acceleration = Vector2.ZERO
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

# Physics Options
export var resolve_angular_velocity = true
export var max_linear_velocity = 800.0
export var max_angular_velocity = 3.0

# Physics Collision
onready var collision_shape = $CollisionShape2D
var bounding_box: BoundingBox
var broadphase_collision = false
var collision_exceptions = []
var collision#: CollisionObject

# Gun
onready var gun = $Gun
var gun_position: Vector2
var gun_rotation: float
var cooldown = 0.2
var cooldown_timer: float

# Functions
const BULLET = preload("res://example_projects/fp_state/bullet.tscn")
const FUNC = preload("res://example_projects/fp_state/ship_func.gd")
var assign_id = funcref(FUNC, "assign_id")
var apply_input = funcref(FUNC, "apply_input")
var limit_velocity = funcref(FUNC, "limit_velocity")
var apply_angular_velocity = funcref(FUNC, "apply_angular_velocity")
var apply_linear_acceleration = funcref(FUNC, "apply_linear_acceleration")
var apply_linear_velocity = funcref(FUNC, "apply_linear_velocity")
var wrap = funcref(FUNC, "wrap")
var create_bullet = funcref(FUNC, "create_bullet")
var set_cooldown = funcref(FUNC, "set_cooldown")
var update_bounding_box = funcref(FUNC, "update_bounding_box")
var broad_phase_collision_detection = funcref(FUNC, "broad_phase_collision_detection")
var narrow_phase_collision_detection = funcref(FUNC, "narrow_phase_collision_detection")
var clear_collision = funcref(FUNC, "clear_collision")

var draw_debug_bounding_box = funcref(FUNC, "draw_debug_bounding_box")
