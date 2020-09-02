class_name KinematicRigidBody2D
extends KinematicBody2D

signal collided(collision)

export var max_linear_velocity = 100.0
export var max_angular_velocity = 3.0

var linear_velocity = Vector2.ZERO
var angular_velocity = 0
var mass = 5.0
var bounce = 0.0

func simulate(delta):
    if linear_velocity.length() > max_linear_velocity * 10:
        linear_velocity = linear_velocity.normalized() * max_linear_velocity * 10
    
    if abs(angular_velocity) > max_angular_velocity:
        angular_velocity = sign(angular_velocity) * max_angular_velocity
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        bounce_collision(collision)
        emit_signal("collided", collision)
    global_rotation += angular_velocity * delta

func bounce_collision(collision : KinematicCollision2D):
    Data.bounce(self, collision)
