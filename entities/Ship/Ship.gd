extends BaseNode2D

class_name Ship

onready var state_machine = get_child_of_type(StateMachine)
onready var world = get_parent()

func state_name():
    return state_machine.active_state_name


# Just some DEBUG code to test different states...
func _process(_delta):
    if world.input.previous_state:
        state_machine.set_previous_state()
    elif world.input.next_state:
        state_machine.set_next_state()
