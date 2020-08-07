class_name Ship
extends Node2D

#warning-ignore:unused_signal
signal gun_fired(gun_position, gun_rotation, ship, velocity_magnitude)

var input = Data.NULL_INPUT

onready var state_machine = $States

func init(init_input):
    input = init_input
    return self

func _ready():
    update_input(input)

func _physics_process(_delta):    
    if input.fire:
        if state_machine.active_state:
            if state_machine.active_state.has_node("Gun"):
                var gun = state_machine.active_state.get_node("Gun")
                if gun.is_ready:
                    gun.fire()
                    emit_signal("gun_fired", gun.global_position, gun.global_rotation, state_machine.active_state, gun.shoot_velocity)
    
    # Just some DEBUG code to test different states...
    if input.previous_state:
        state_machine.set_previous_state()
    elif input.next_state:
        state_machine.set_next_state()

    if state_machine && state_machine.active_state && state_machine.active_state.get_node("CollisionShape2D"):
        var state = state_machine.active_state
        var linear_velocity = state.linear_velocity if state.get("linear_velocity") else Vector2.ZERO
        var angular_velocity = state.angular_velocity if state.get("angular_velocity") else 0
        $Data.update(state.global_position, state.global_rotation, state.get_node("CollisionShape2D").scale, linear_velocity, angular_velocity)

func state_name():
    return state_machine.active_state_name

func update_input(new_input):
    input = new_input
    for state in state_machine.states:
        if "input" in state:
            state.input = input

func set_position(new_position):
    position = new_position
    var state = state_machine.active_state
    if state is RigidBody2D:
        state.global_position = new_position
