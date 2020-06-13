extends RigidBody2D

signal integrate_forces(state)

onready var root = get_tree().get_root()
export (Resource) var bullet_particles_scene = preload("res://entities/Bullet/BulletParticles.tscn")

func start(current_velocity, shoot_velocity):
    linear_velocity = current_velocity + Vector2(0, -shoot_velocity).rotated(rotation)
    print("Shoot! " + String(current_velocity) + " " + String(linear_velocity))

func _integrate_forces(state):
    emit_signal("integrate_forces", state)

func _on_DestroyAfter_timeout():
    destroy()

func _on_Bullet_body_entered(body):
    destroy()

func destroy():
    var bullet_particles = bullet_particles_scene.instance()
    root.add_child(bullet_particles)
    bullet_particles.position = global_position
    bullet_particles.emitting = true
    queue_free()
