extends Node2D

onready var rigidbody = $RigidBody2DNode2DLink

func state_enter(previous_state):
    print("[Entering] State Transition from ", previous_state.name, " to ", name, "  ", String(previous_state.position.x))
    
    if previous_state is Node2D:
        position = previous_state.position
        rotation = previous_state.rotation
    else:
        position = Vector2(0,0)
        rotation = 0
    
    if previous_state.get("rigidbody"):
        rigidbody.linear_velocity = previous_state.rigidbody.linear_velocity
        rigidbody.angular_velocity = previous_state.rigidbody.angular_velocity
    else:
        rigidbody.linear_velocity = Vector2(0,0)
        rigidbody.angular_velocity = 0
