extends RigidBody2D

export var horizontal = 0
export var vertical = 0

export var engine_thrust = 500
export var spin_thrust = 500
export var max_speed = 500

var thrust = Vector2()
var rotation_dir = 0

onready var gun = $CollisionShape2D/Gun

func _process(_delta):
    thrust = Vector2(0, vertical * engine_thrust)
    rotation_dir = horizontal

func _physics_process(delta):
    set_applied_force(thrust.rotated(global_rotation))
    
    angular_velocity = rotation_dir * spin_thrust * delta
    #set_applied_torque(rotation_dir * spin_thrust)
    
    if linear_velocity.length() > max_speed:
        linear_velocity = linear_velocity.normalized() * max_speed

func change_position(new_position):
    self.new_position = new_position

func _integrate_forces(state):
    $Wrap.wrap(state)

func state_enter(previous_state):
    if previous_state is Node2D:
        position = previous_state.position
        rotation = previous_state.rotation
    else:
        position = Vector2(0,0)
        rotation = 0
    
    if previous_state is RigidBody2D:
        linear_velocity = previous_state.linear_velocity
        angular_velocity = previous_state.angular_velocity
    else:
        linear_velocity = Vector2(0,0)
        angular_velocity = 0
    
    $LabelNode2D.global_rotation = 0
