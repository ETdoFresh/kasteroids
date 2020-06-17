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
var was_pressed = false
func _input(_event):
    if Input.is_key_pressed(KEY_COMMA):
        if not was_pressed:
            state_machine.set_previous_state()
        was_pressed = true
    elif Input.is_key_pressed(KEY_PERIOD):
        if not was_pressed:
            state_machine.set_next_state()
        was_pressed = true
    else:
        was_pressed = false
