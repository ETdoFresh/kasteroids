extends Node

signal collided(collision)

export var mass = 5.0
export var bounce_coeff = 0.0
export var resolve_angular_velocity = true
export var max_linear_velocity = 100.0
export var max_angular_velocity = 3.0

var collision_manager
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

onready var parent = get_parent()

func simulate(obj, delta):
    if linear_velocity.length() > max_linear_velocity * 10:
        linear_velocity = linear_velocity.normalized() * max_linear_velocity * 10
    
    if abs(angular_velocity) > max_angular_velocity:
        angular_velocity = sign(angular_velocity) * max_angular_velocity
    
    obj.global_rotation += angular_velocity * delta
    var collision = obj.move_and_collide(linear_velocity * delta)
    if collision && collision_manager:
        collision_manager.register_collision(parent, collision)

func resolve(collision):
    if resolve_angular_velocity:
        CollisionResolver.bounce(parent, collision)
    else:
        CollisionResolver.bounce_no_angular_velocity(parent, collision)
    emit_signal("collided", collision)
