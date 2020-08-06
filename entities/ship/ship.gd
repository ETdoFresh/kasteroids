class_name Ship
extends BaseNode2D

#warning-ignore:unused_signal
signal create(scene, position, rotation, rigidbody, velocity_magnitude)

var input = Data.NULL_INPUT

func _ready():
    update_input(input)

func _process(_delta):
    if input.fire:
        if $States.active_state:
            if $States.active_state.has_node("Gun"):
                var gun = $States.active_state.get_node("Gun")
                gun.fire(self, $States.active_state)
    
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
