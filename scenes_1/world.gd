extends Node2D

var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false

var state = []

func _ready():
    $Ship.connect("create", $Bullets, "create")

func _process(_delta):
    Util.copy_input_variables(self, $Ship)

func add_state_node(node):
    state.append(node)

func remove_state_node(node):
    for i in range(state.size() - 1, -1, -1):
        if (state[i] == node):
            state.remove(i)
