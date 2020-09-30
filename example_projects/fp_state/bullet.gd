extends KinematicBody2D

const PARTICLES = preload("res://entities/bullet/bullet_particles.tscn")
const FUNC = preload("res://example_projects/fp_state/ship_func.gd")

export var speed = 800.0
export var destroy_timer = 1

var linear_velocity = Vector2.ZERO
var collision_exceptions = []
var collision: CollisionObject
var queue_delete = false

var apply_linear_velocity = funcref(FUNC, "apply_linear_velocity")
var wrap = funcref(FUNC, "wrap")
var update_destroy_timer = funcref(FUNC, "update_destroy_timer")
var queue_delete_bullet_on_timeout = funcref(FUNC, "queue_delete_bullet_on_timeout")
var spawn_bullet_particles_on_delete = funcref(FUNC, "spawn_bullet_particles_on_delete")
var delete_object = funcref(FUNC, "delete_object")
