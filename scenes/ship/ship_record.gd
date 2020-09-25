class_name ShipRecord
extends Record

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
var linear_velocity: LinearVelocityRecord
var angular_velocity: AngularVelocityRecord

# ColliderShape2D
var collision_shape_2d: CollisionShape2DRecord

# Gun
var gun_position: PositionRecord
var gun_rotation: RotationRecord
var cooldown: CooldownRecord
var cooldown_timer: CooldownTimerRecord
