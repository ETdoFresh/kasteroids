extends RigidBody2DExt

class_name Ship

signal fire

export (int) var engine_thrust = 500
export (int) var spin_thrust = 500
export (int) var max_speed = 500

export (NodePath) var input_path

onready var input = get_node(input_path)

var thrust = Vector2()
var rotation_dir = 0

func _enter_tree():
    Global.emit_signal("node_created", self)

func _exit_tree():
    Global.emit_signal("node_destroyed", self)

#warning-ignore:unused_argument
func _process(delta):
    thrust = Vector2(0, input.vertical * engine_thrust)
    rotation_dir = input.horizontal
    if input.fire:  emit_signal("fire")

func _physics_process(delta):
    set_applied_force(thrust.rotated(rotation))
    
    angular_velocity = rotation_dir * spin_thrust * delta
    #set_applied_torque(rotation_dir * spin_thrust)
    
    if linear_velocity.length() > max_speed:
        linear_velocity = linear_velocity.normalized() * max_speed

