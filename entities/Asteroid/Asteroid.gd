extends BaseNode2D

class_name Asteroid

export var min_angular_velocity = -3.0
export var max_angular_velocity = 3.0
export var min_linear_velocity = 20.0
export var max_linear_velocity = 100.0
export var min_scale = 0.75
export var max_scale = 1.0

var random = RandomNumberGenerator.new()
onready var rigidbody = $RigidBody2DNode2DLink

func _ready():
    random.randomize()
    randomize_spin()
    randomize_speed()
    randomize_scale()
    
func _enter_tree():
    Global.emit_signal("node_created", self)

func _exit_tree():
    Global.emit_signal("node_destroyed", self)

func randomize_spin():
    rigidbody.angular_velocity = random.randf_range(min_angular_velocity, max_angular_velocity)

func randomize_speed():
    var random_direction = Vector2(1,0).rotated(random.randf() * 2 * PI)
    rigidbody.linear_velocity = random_direction
    rigidbody.linear_velocity *= random.randf_range(min_linear_velocity, max_linear_velocity)

func randomize_scale():
    scale = Vector2(1,1)
    scale *= random.randf_range(min_scale, max_scale)
