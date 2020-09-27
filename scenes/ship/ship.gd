class_name Ship
extends Node2D

export var speed = 800.0
export var spin = 10.0
export var max_speed = 800.0
export var mass = 1.0
export var bounce = 0.7
export var linear_acceleration = Vector2.ZERO
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0
export var cooldown = 0.2
export var cooldown_timer = 0.0

var record

onready var input = $Input
onready var collision_shape_2d = $CollisionShape2D
onready var sprite = $Sprite
onready var gun : Node2D = $Gun

func set_record(new_record : ShipRecord):
    record = new_record
    speed = record.speed.value
    spin = record.spin.value
    max_speed = record.max_speed.value
    global_position.x = record.position.x
    global_position.y = record.position.y
    global_rotation = record.rotation.value
    global_scale.x = record.scale.x
    global_scale.y = record.scale.y
    mass = record.mass.value
    bounce = record.bounce.value
    linear_acceleration.x = record.linear_acceleration.x
    linear_acceleration.y = record.linear_acceleration.y
    linear_velocity.x = record.linear_velocity.x
    linear_velocity.y = record.linear_velocity.y
    angular_velocity = record.angular_velocity.value
    #gun.global_position.x = record.gun_position.x
    #gun.global_position.y = record.gun_position.y
    cooldown = record.cooldown.value
    cooldown_timer = record.cooldown_timer.value
    input.horizontal = record.input.horizontal
    input.vertical = record.input.vertical
    input.fire = record.input.fire

func get_record():
    if not record:
        record = ShipRecord.new()
        record.node = self
        record.speed = SpeedRecord.new().init(speed)
        record.spin = SpinRecord.new().init(spin)
        record.max_speed = MaxSpeedRecord.new().init(max_speed)
        record.position = PositionRecord.new().init(global_position)
        record.rotation = RotationRecord.new().init(global_rotation)
        record.scale = ScaleRecord.new().init(global_scale)
        record.mass = MassRecord.new().init(mass)
        record.bounce = BounceRecord.new().init(bounce)
        record.linear_acceleration = LinearAccelerationRecord.new().init(linear_acceleration)
        record.linear_velocity = LinearVelocityRecord.new().init(linear_velocity)
        record.angular_velocity = AngularVelocityRecord.new().init(angular_velocity)
        record.collision_shape_2d = CollisionShape2DConvexPolygonRecord.new().init(collision_shape_2d.shape.points)
        record.gun_position = PositionRecord.new().init(gun.position)
        record.gun_rotation = RotationRecord.new().init(gun.rotation)
        record.cooldown = CooldownRecord.new().init(cooldown)
        record.cooldown_timer = CooldownTimerRecord.new().init(cooldown_timer)
        record.input = InputRecord.new().init(input.horizontal, input.vertical, input.fire)
    return record

func get_new_input_record():
    return InputRecord.new().init(input.horizontal, input.vertical, input.fire)
