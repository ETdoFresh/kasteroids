extends BaseNode2D

class_name Ship

export (NodePath) var input_path

var input = {"horizontal": 0, "vertical": 0, "fire": false}

onready var state_machine = get_child_of_type(StateMachine)
onready var state_index = 0


func _ready():
    if has_node(input_path):
        input = get_node(input_path)

func state_name():
    return state_machine.active_state_name

func _enter_tree():
    Global.emit_signal("node_created", self)

func _exit_tree():
    Global.emit_signal("node_destroyed", self)


# Just some DEBUG code to test different states...
func _process(_delta):
    if input.previous_state:
        state_machine.set_previous_state()
    elif input.next_state:
        state_machine.set_next_state()
