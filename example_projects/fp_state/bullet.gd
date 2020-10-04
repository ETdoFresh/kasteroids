extends Node2D

# Node
var id = -1
var spawn = false
var queue_delete = false

# Bullet
const PARTICLES = preload("res://entities/bullet/bullet_particles.tscn")
onready var spawn_sound = $SpawnSound
export var speed = 800.0
export var destroy_timer = 1

# Physics Body
var mass = 0.2
var bounce = 0.0
var linear_velocity = Vector2.ZERO
var angular_velocity = 0.0

# Physics Collision
onready var collision_shape = $CollisionShape2D
var bounding_box: Rect2
var broadphase_collision = false
var collision#: CollisionObject
var collision_exceptions = []

# Functions
const FUNC = preload("res://example_projects/fp_state/ship_func.gd")
var assign_id = funcref(FUNC, "assign_id")
var apply_linear_velocity = funcref(FUNC, "apply_linear_velocity")
var wrap = funcref(FUNC, "wrap")
var update_destroy_timer = funcref(FUNC, "update_destroy_timer")
var queue_delete_bullet_on_timeout = funcref(FUNC, "queue_delete_bullet_on_timeout")
var spawn_bullet_particles_on_delete = funcref(FUNC, "spawn_bullet_particles_on_delete")
var delete_object = funcref(FUNC, "delete_object")
var play_spawn_sound = funcref(FUNC, "play_spawn_sound")
var clear_spawn = funcref(FUNC, "clear_spawn")
var update_bounding_box = funcref(FUNC, "update_bounding_box")
var broad_phase_collision_detection = funcref(FUNC, "broad_phase_collision_detection")
var narrow_phase_collision_detection = funcref(FUNC, "narrow_phase_collision_detection")
var clear_collision = funcref(FUNC, "clear_collision")
var queue_delete_bullet_on_collide = funcref(FUNC, "queue_delete_bullet_on_collide")
var resolve_collision = funcref(FUNC, "resolve_collision")
var fix_penetration = funcref(FUNC, "fix_penetration")

var draw_debug_bounding_box = funcref(FUNC, "draw_debug_bounding_box")
