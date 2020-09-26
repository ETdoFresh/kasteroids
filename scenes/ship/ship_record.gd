class_name ShipRecord
extends Record

# Node
var node: Node

# Ship
var speed: SpeedRecord
var spin: SpinRecord

# Transform
var position: PositionRecord
var rotation: RotationRecord
var scale: ScaleRecord

# RigidBody2D
var mass: MassRecord
var bounce: BounceRecord
var linear_acceleration: LinearAccelerationRecord
var linear_velocity: LinearVelocityRecord
var angular_velocity: AngularVelocityRecord

# ColliderShape2D
var collision_shape_2d: CollisionShape2DRecord

# Gun
var gun_position: PositionRecord
var gun_rotation: RotationRecord
var cooldown: CooldownRecord
var cooldown_timer: CooldownTimerRecord

# Input
var input: InputRecord

func duplicate():
    var duplicate = get_script().new()
    duplicate.node = node
    duplicate.speed = speed
    duplicate.spin = spin
    duplicate.position = position
    duplicate.rotation = rotation
    duplicate.scale = scale
    duplicate.mass = mass
    duplicate.bounce = bounce
    duplicate.linear_acceleration = linear_acceleration
    duplicate.linear_velocity = linear_velocity
    duplicate.angular_velocity = angular_velocity
    duplicate.collision_shape_2d = collision_shape_2d
    duplicate.gun_position = gun_position
    duplicate.gun_rotation = gun_rotation
    duplicate.cooldown = cooldown
    duplicate.cooldown_timer = cooldown_timer
    duplicate.input = input
    return duplicate
