extends Node2D

onready var static_body = $StaticBody2D
onready var static_body_shape = $StaticBody2D/CollisionShape2D
onready var rigid_body = $RigidBody2D
onready var rigid_body_shape = $RigidBody2D/CollisionShape2D

var velocity = Vector2.ZERO

func _process(delta):
    velocity += Vector2(0, 9.8 * 2 * delta)
    rigid_body.move_and_collide(velocity)
