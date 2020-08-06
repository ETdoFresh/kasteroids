class_name Ship
extends Node2D

#warning-ignore:unused_signal
signal gun_fired(gun_position, gun_rotation, ship, velocity_magnitude)

var input = Data.NULL_INPUT

func init(init_input):
    input = init_input
    return self

func _ready():
    update_input(input)

func _physics_process(_delta):
    if input.fire:
        if $States.active_state:
            if $States.active_state.has_node("Gun"):
                var gun = $States.active_state.get_node("Gun")
                if gun.is_ready:
                    gun.fire()
                    emit_signal("gun_fired", gun.global_position, gun.global_rotation, $States.active_state, gun.shoot_velocity)
    
    # Just some DEBUG code to test different states...
    if input.previous_state:
        $States.set_previous_state()
    elif input.next_state:
        $States.set_next_state()

    if $States && $States.active_state && $States.active_state.get_node("CollisionShape2D"):
        var state = $States.active_state
        $Data.update(state.global_position, state.global_rotation, state.get_node("CollisionShape2D").scale)

func state_name():
    return $States.active_state_name

func update_input(new_input):
    input = new_input
    for state in $States.states:
        if "input" in state:
            state.input = input

func set_position(new_position):
    position = new_position
    var state = $States.active_state
    if state is RigidBody2D:
        state.global_position = new_position
