extends RigidBody2D

signal integrate_forces(state)

func _ready():
	angular_velocity = 5
	linear_velocity = Vector2(20,0)

func _integrate_forces(state):
	emit_signal("integrate_forces", state)
