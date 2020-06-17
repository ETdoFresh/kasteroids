extends Node2D

onready var input = $Input

var state = []

func add_state_node(node):
    state.append(node)

func remove_state_node(node):
    for i in range(state.size() - 1, -1, -1):
        if (state[i] == node):
            state.remove(i)
