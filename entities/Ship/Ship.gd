extends RigidBody2D

signal fire
signal integrate_forces(state)

export (int) var engine_thrust = 500
export (int) var spin_thrust = 500
export (int) var max_speed = 500

export (NodePath) var input_path

onready var input = get_node(input_path)
var thrust = Vector2()
var rotation_dir = 0

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

func _integrate_forces(state):
    emit_signal("integrate_forces", state)
