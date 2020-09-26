class_name Asteroid
extends Node2D

export var mass = 5.0
export var bounce = 0.2
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0.0

var record setget set_record, get_record

onready var collision_shape_2d = $CollisionShape2D
onready var collision_sound = $CollisionSound
onready var sprite = $Sprite

func set_record(new_record : AsteroidRecord):
    record = new_record
    global_position.x = record.position.x
    global_position.y = record.position.y
    global_rotation = record.rotation.value
    global_scale.x = record.scale.x
    global_scale.y = record.scale.y
    mass = record.mass.value
    bounce = record.bounce.value
    linear_velocity.x = record.linear_velocity.x
    linear_velocity.y = record.linear_velocity.y
    angular_velocity = record.angular_velocity.value

func get_record():
    if not record:
        record = AsteroidRecord.new()
        record.node = self
        record.position = PositionRecord.new().init(global_position)
        record.rotation = RotationRecord.new().init(global_rotation)
        record.scale = ScaleRecord.new().init(global_scale)
        record.mass = MassRecord.new().init(mass)
        record.bounce = BounceRecord.new().init(bounce)
        record.linear_velocity = LinearVelocityRecord.new().init(linear_velocity)
        record.angular_velocity = AngularVelocityRecord.new().init(angular_velocity)
        record.collision_shape_2d = CollisionShape2DCircleRecord.new().init(collision_shape_2d.shape.radius)
    return record
