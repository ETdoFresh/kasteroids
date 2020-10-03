class_name Collision

var point: Vector2
var normal: Vector2
var position: Vector2
var mass: float
var bounce: float
var linear_velocity: Vector2
var angular_velocty: float
var other: Node2D
var other_position: Vector2
var other_mass: float
var other_bounce: float
var other_linear_velocity: Vector2
var other_angular_velocty: float

func init(obj: Node2D, init_other: Node2D, contact: Vector2):
    point = contact
    position = obj.global_position
    mass = obj.mass
    bounce = obj.bounce
    linear_velocity = obj.linear_velocity
    angular_velocty = obj.angular_velocity
    other = init_other
    other_position = other.global_position
    other_mass = other.mass
    other_bounce = other.bounce
    other_linear_velocity = other.linear_velocity
    other_angular_velocty = other.angular_velocity
    normal = (position - other_position).normalized()
    return self
