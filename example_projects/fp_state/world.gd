extends Node2D

const STATE = preload("res://example_projects/fp_state/state.gd")

var state: STATE = STATE.new()

func _ready():
    state.tick = 0
    state.objects = get_children()

func _process(delta):
    map(state.objects, "apply_input")
    fold1(state.objects, "create_bullet", state.objects, self)
    map(state.objects, "assign_id")
    map1(state.objects, "set_cooldown", delta)
    map(state.objects, "limit_velocity")
    map1(state.objects, "apply_angular_velocity", delta)
    map1(state.objects, "apply_linear_acceleration", delta)
    map1(state.objects, "apply_linear_velocity", delta)
    map(state.objects, "wrap")
    map(state.objects, "add_new_collision")
    map(state.objects, "resolve_new_collision")
    map1(state.objects, "update_destroy_timer", delta)
    map(state.objects, "queue_delete_bullet_on_collide")
    map(state.objects, "queue_delete_bullet_on_timeout")
    map(state.objects, "spawn_bullet_particles_on_delete")
    map(state.objects, "delete_object")
    $Label.text = "FPS: %s" % Engine.get_frames_per_second()
    $Label.text += "\nObjects: %s" % state.objects.size()

func connect_new_input(input):
    var ship = input.new_ship()
    ship.input = input
    state.objects.append(ship)

func disconnect_input(input):
    map1(state.objects, "queue_delete_input", input)
    map(state.objects, "delete_object")

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

func fold(array: Array, func_name: String, accumulator):
    for i in range(array.size()):
        if func_name in array[i]:
            accumulator = array[i][func_name].call_func(array[i], accumulator)
    return array

func fold1(array: Array, func_name: String, accumulator, arg):
    for i in range(array.size()):
        if func_name in array[i]:
            accumulator = array[i][func_name].call_func(array[i], accumulator, arg)
    return array
