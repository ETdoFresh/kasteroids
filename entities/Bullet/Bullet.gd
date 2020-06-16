extends Node2D

class_name Bullet

signal integrate_forces(state)

onready var root = get_tree().get_root()
onready var rigidbody = $RigidBody2DNode2DLink

export (Resource) var bullet_particles_scene = preload("res://entities/Bullet/BulletParticles.tscn")

func start(current_velocity, shoot_velocity):
    rigidbody.linear_velocity = current_velocity + Vector2(0, -shoot_velocity).rotated(rotation)

func _enter_tree():
    Global.emit_signal("node_created", self)

func _exit_tree():
    Global.emit_signal("node_destroyed", self)

func _integrate_forces(state):
    emit_signal("integrate_forces", state)

func _on_DestroyAfter_timeout():
    destroy()

#warning-ignore:unused_argument
func _on_RigidBody2DNode2DLink_body_entered(body):
    destroy()

func destroy():
    var bullet_particles = bullet_particles_scene.instance()
    root.add_child(bullet_particles)
    bullet_particles.position = global_position
    bullet_particles.emitting = true
    queue_free()
