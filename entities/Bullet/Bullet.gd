extends RigidBody2D

signal integrate_forces(state)

func start(current_velocity, shoot_velocity):
    linear_velocity = current_velocity + Vector2(0, -shoot_velocity).rotated(rotation)

func _integrate_forces(state):
    emit_signal("integrate_forces", state)

func _on_DestroyAfter_timeout():
    queue_free()
