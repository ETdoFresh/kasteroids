extends Node2D

# Node
var id = -1
var queue_delete = false

# Asteroid
export var random_linear_velocity = Vector2(20, 100)
export var random_angular_velocity = Vector2(-3, 3)
export var random_scale = Vector2(0.75, 1)

# Physics Body
export var mass = 5.0
export var bounce = 0.0
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

# Physics Options
export var max_linear_velocity = 800.0
export var max_angular_velocity = 3.0

# Physics Collision
onready var collision_shape = $CollisionShape2D
onready var collision_sound = $CollisionSound
var bounding_box: Rect2
var broadphase_collision = false
var collision#: CollisionObject
var collision_exceptions = []

# Functions
const FUNC = preload("res://example_projects/fp_state/ship_func.gd")
var assign_id = funcref(FUNC, "assign_id")
var limit_velocity = funcref(FUNC, "limit_velocity")
var apply_angular_velocity = funcref(FUNC, "apply_angular_velocity")
var apply_linear_velocity = funcref(FUNC, "apply_linear_velocity")
var wrap = funcref(FUNC, "wrap")
var randomize_linear_velocity = funcref(FUNC, "randomize_linear_velocity")
var randomize_angular_velocity = funcref(FUNC, "randomize_angular_velocity")
var randomize_scale = funcref(FUNC, "randomize_scale")
var update_bounding_box = funcref(FUNC, "update_bounding_box")
var broad_phase_collision_detection = funcref(FUNC, "broad_phase_collision_detection")
var narrow_phase_collision_detection = funcref(FUNC, "narrow_phase_collision_detection")
var clear_collision = funcref(FUNC, "clear_collision")
var resolve_collision = funcref(FUNC, "resolve_collision")
var play_collision_sound = funcref(FUNC, "play_collision_sound")

var draw_debug_bounding_box = funcref(FUNC, "draw_debug_bounding_box")
