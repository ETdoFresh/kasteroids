class_name ShipRecord
extends Record

# ID
var id: IdRecord

# Node
var node: Node

# Ship
var speed: SpeedRecord
var spin: SpinRecord
var max_speed: MaxSpeedRecord

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
var collision_exceptions: CollisionExceptionsRecord
var collision_shape_2d: CollisionShape2DRecord
var collision: PossibleCollisionRecord
var bounding_box: BoundingBoxRecord

# Gun
var gun_position: PositionRecord
var gun_rotation: RotationRecord
var cooldown: CooldownRecord
var cooldown_timer: CooldownTimerRecord

# Input
var input: InputRecord

func duplicate():
    var duplicate = get_script().new()
    duplicate.id = id
    duplicate.node = node
    duplicate.speed = speed
    duplicate.spin = spin
    duplicate.max_speed = max_speed
    duplicate.position = position
    duplicate.rotation = rotation
    duplicate.scale = scale
    duplicate.mass = mass
    duplicate.bounce = bounce
    duplicate.linear_acceleration = linear_acceleration
    duplicate.linear_velocity = linear_velocity
    duplicate.angular_velocity = angular_velocity
    duplicate.collision_exceptions = collision_exceptions
    duplicate.collision_shape_2d = collision_shape_2d
    duplicate.collision = collision
    duplicate.bounding_box = bounding_box
    duplicate.gun_position = gun_position
    duplicate.gun_rotation = gun_rotation
    duplicate.cooldown = cooldown
    duplicate.cooldown_timer = cooldown_timer
    duplicate.input = input
    return duplicate
