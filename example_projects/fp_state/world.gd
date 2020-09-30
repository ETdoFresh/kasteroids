extends Node2D

const STATE = preload("res://example_projects/fp_state/state.gd")

var state = STATE.new()

func _ready():
    state.tick = 0
    state.objects = get_children()

func _process(delta):
    map(state.objects, "apply_input")
    map(state.objects, "limit_velocity")
    map1(state.objects, "apply_angular_velocity", delta)
    map1(state.objects, "apply_linear_acceleration", delta)
    map1(state.objects, "apply_linear_velocity", delta)
    map(state.objects, "wrap")

func map(array: Array, func_name: String):
    for i in range(array.size()):
        if func_name in array[i]:
            array[i] = array[i][func_name].call_func(array[i])
    return array

func map1(array: Array, func_name: String, arg): # 1 arg
    for i in range(array.size()):
        if func_name in array[i]:
            array[i] = array[i][func_name].call_func(array[i], arg)
    return array
