class_name Bullet
extends RigidBody2D

export (Resource) var bullet_particles_scene = preload("res://entities/bullet/bullet_particles.tscn")

func _ready():
    connect("body_entered", self, "_on_self_body_entered")

func start(position, rotation, rigidbody, velocity_magnitude):
    global_position = position
    global_rotation = rotation
    add_collision_exception_with(rigidbody)
    
    var ship_velocity = rigidbody.linear_velocity
    linear_velocity = ship_velocity + Vector2(0, -velocity_magnitude).rotated(rotation)

func _integrate_forces(state):
    $Wrap.wrap(state)

func _on_DestroyAfter_timeout():
    destroy()

func _on_self_body_entered(_body):
    destroy()

func destroy():
    var bullet_particles = bullet_particles_scene.instance()
    owner.add_child(bullet_particles)
    bullet_particles.position = global_position
    bullet_particles.emitting = true
    queue_free()
