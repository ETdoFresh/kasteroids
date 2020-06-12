extends RigidBody2D

export var speed = 300

signal integrate_forces(state)

func _ready():
	linear_velocity = Vector2(0, -speed)
	
func _integrate_forces(state):
	emit_signal("integrate_forces", state)
