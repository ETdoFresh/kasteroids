extends RigidBody2D

signal fire
signal integrate_forces(state)

export (int) var engine_thrust = 500
export (int) var spin_thrust = 500
export (int) var max_speed = 500

var thrust = Vector2()
var rotation_dir = 0

var up = false
var down = false
var left = false
var right = false
var fire = false

func _on_Virtual_Controls2_down_pressed():	down = true
func _on_Virtual_Controls2_down_released():	down = false
func _on_Virtual_Controls2_fire_pressed():	fire = true
func _on_Virtual_Controls2_fire_released():	fire = false
func _on_Virtual_Controls2_left_pressed():	left = true
func _on_Virtual_Controls2_left_released():	left = false
func _on_Virtual_Controls2_right_pressed():	right = true
func _on_Virtual_Controls2_right_released():	right = false
func _on_Virtual_Controls2_up_pressed():	up = true
func _on_Virtual_Controls2_up_released():	up = false

func _process(delta):	
    
    if up || Input.is_action_pressed("ui_up"):
        thrust = Vector2(0, -engine_thrust)
    elif down || Input.is_action_pressed("ui_down"):
        thrust = Vector2(0, engine_thrust)
    else:
        thrust = Vector2()
        
    rotation_dir = 0
    if left || Input.is_action_pressed("ui_left"): 
        rotation_dir -= 1
    if right || Input.is_action_pressed("ui_right"):
        rotation_dir += 1
        
    if fire || Input.is_action_just_pressed("ui_select"):
        emit_signal("fire")
        fire = false

func _physics_process(delta):
    set_applied_force(thrust.rotated(rotation))
    
    angular_velocity = rotation_dir * spin_thrust * delta
    #set_applied_torque(rotation_dir * spin_thrust)
    
    if linear_velocity.length() > max_speed:
        linear_velocity = linear_velocity.normalized() * max_speed

func _integrate_forces(state):
    emit_signal("integrate_forces", state)
