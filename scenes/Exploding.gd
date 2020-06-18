extends RigidBody2D

func _integrate_forces(state):
    $Wrap.wrap(state)

func state_enter(previous_state):
    print("[Entering] State Transition from ", previous_state.name, " to ", name, "  ", String(previous_state.position.x))
    
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
