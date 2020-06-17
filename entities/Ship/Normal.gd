extends Node2DExtended

signal fire

export (int) var engine_thrust = 500
export (int) var spin_thrust = 500
export (int) var max_speed = 500

export (NodePath) var input_path

onready var rigidbody = $RigidBody2DNode2DLink

var thrust = Vector2()
var rotation_dir = 0

#warning-ignore:unused_argument
func _process(delta):
    thrust = Vector2(0, base.input.vertical * engine_thrust)
    rotation_dir = base.input.horizontal
    if base.input.fire:  emit_signal("fire")

func _physics_process(delta):
    rigidbody.set_applied_force(thrust.rotated(global_rotation))
    
    rigidbody.angular_velocity = rotation_dir * spin_thrust * delta
    #set_applied_torque(rotation_dir * spin_thrust)
    
    if rigidbody.linear_velocity.length() > max_speed:
        rigidbody.linear_velocity = rigidbody.linear_velocity.normalized() * max_speed

func state_enter(previous_state):
    if not previous_state:
        return
    
    if previous_state.get("rigidbody"):
        rigidbody.linear_velocity = previous_state.rigidbody.linear_velocity
        rigidbody.angular_velocity = previous_state.rigidbody.angular_velocity
    else:
        rigidbody.linear_velocity = Vector2(0,0)
        rigidbody.angular_velocity = 0
