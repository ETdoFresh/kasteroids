class_name BulletRecord
extends Record

# Node
var node: Node

# Transform
var position: PositionRecord
var rotation: RotationRecord
var scale: ScaleRecord

# RigidBody2D
var mass: MassRecord
var bounce: BounceRecord
var linear_velocity: LinearVelocityRecord
var angular_velocity: AngularVelocityRecord

# ColliderShape2D
var collision_shape_2d: CollisionShape2DRecord

# Destroy Timer
var destroy_timer: DestroyTimerRecord

func duplicate():
    var duplicate = get_script().new()
    duplicate.node = node
    duplicate.position = position
    duplicate.rotation = rotation
    duplicate.scale = scale
    duplicate.mass = mass
    duplicate.bounce = bounce
    duplicate.linear_velocity = linear_velocity
    duplicate.angular_velocity = angular_velocity
    duplicate.collision_shape_2d = collision_shape_2d
    duplicate.destroy_timer = destroy_timer
    return duplicate
