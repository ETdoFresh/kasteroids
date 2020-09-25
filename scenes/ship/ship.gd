class_name Ship
extends Node2D

export var speed = 800.0
export var spin = 10.0
export var mass = 1.0
export var bounce = 0.7
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0
export var cooldown = 0.2
export var cooldown_timer = 0.0

var record setget set_record, get_record

onready var input = $Input
onready var collision_shape_2d = $CollisionShape2D
onready var sprite = $Sprite
onready var gun : Node2D = $Gun

func set_record(new_record : ShipRecord):
    record = new_record
    speed = record.speed
    spin = record.spin
    global_position.x = record.position.x
    global_position.y = record.position.y
    global_rotation = record.rotation.value
    global_scale.x = record.scale.x
    global_scale.y = record.scale.y
    mass = record.mass.value
    bounce = record.bounce.value
    linear_velocity = record.linear_velocity.value
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
        record.speed = SpeedRecord.new(speed)
        record.spin = SpinRecord.new(spin)
        record.position = PositionRecord.new(global_position)
        record.rotation = RotationRecord.new(global_rotation)
        record.scale = ScaleRecord.new(global_scale)
        record.mass = MassRecord.new(mass)
        record.bounce = BounceRecord.new(bounce)
        record.linear_velocity = LinearVelocityRecord.new(linear_velocity)
        record.angular_velocity = AngularVelocityRecord.new(angular_velocity)
        record.collision_shape_2d = CollisionShape2DConvexPolygonRecord.new(collision_shape_2d.shape.points)
        record.gun_position = PositionRecord.new(gun.global_position)
        record.gun_rotation = RotationRecord.new(gun.global_rotation)
        record.cooldown = CooldownRecord.new(cooldown)
        record.cooldown_timer = CooldownTimerRecord.new(cooldown_timer)
        record.input = InputRecord.new(input.horizontal, input.vertical, input.fire)
    return record

func update_input():
    record.input = InputRecord.new(input.horizontal, input.vertical, input.fire)
