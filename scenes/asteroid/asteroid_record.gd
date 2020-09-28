class_name AsteroidRecord
extends Record

# ID
var id: IdRecord

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
var collision_exceptions: CollisionExceptionsRecord
var collision_shape_2d: CollisionShape2DRecord
var collision: PossibleCollisionRecord
var bounding_box: BoundingBoxRecord

func duplicate():
    var duplicate = get_script().new()
    duplicate.id = id
    duplicate.node = node
    duplicate.position = position
    duplicate.rotation = rotation
    duplicate.scale = scale
    duplicate.mass = mass
    duplicate.bounce = bounce
    duplicate.linear_velocity = linear_velocity
    duplicate.angular_velocity = angular_velocity
    duplicate.collision_exceptions = collision_exceptions
    duplicate.collision_shape_2d = collision_shape_2d
    duplicate.collision = collision
    duplicate.bounding_box = bounding_box
    return duplicate
