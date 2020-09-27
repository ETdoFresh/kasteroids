extends Node2D

export var speed = 800
export var mass = 0.15
export var bounce = 0.2
export var linear_velocity = Vector2.ZERO
export var angular_velocity = 0
export var destroy_timer = 1.0
export var radius = 12.5

var record

onready var spawn_sound = $SpawnSound
#onready var collision_sound = $CollisionSound
onready var sprite = $Sprite

func set_record(new_record : BulletRecord):
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
    destroy_timer = record.destroy_timer.value

func get_record():
    if not record:
        record = BulletRecord.new()
        record.node = self
        record.position = PositionRecord.new().init(position)
        record.rotation = RotationRecord.new().init(rotation)
        record.scale = ScaleRecord.new().init(scale)
        record.mass = MassRecord.new().init(mass)
        record.bounce = BounceRecord.new().init(bounce)
        record.linear_velocity = LinearVelocityRecord.new().init(linear_velocity)
        record.angular_velocity = AngularVelocityRecord.new().init(angular_velocity)
        record.collision_shape_2d = CollisionShape2DCircleRecord.new().init(radius)
        record.destroy_timer = DestroyTimerRecord.new().init(destroy_timer)
    return record
