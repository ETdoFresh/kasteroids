extends Node2D

const STATE = preload("res://example_projects/fp_state/state.gd")

var state: STATE = STATE.new()

func _ready():
    state.tick = 0
    state.objects = get_children()

func _process(delta):
    map(state.objects, "apply_input")
    fold1(state.objects, "create_bullet", state.objects, self)
    fold(state.objects, "assign_id", state)
    map1(state.objects, "set_cooldown", delta)
    map(state.objects, "limit_velocity")
    map1(state.objects, "apply_angular_velocity", delta)
    map1(state.objects, "apply_linear_acceleration", delta)
    map1(state.objects, "apply_linear_velocity", delta)
    map(state.objects, "wrap")
    map(state.objects, "add_new_collision") # TODO
    map(state.objects, "resolve_new_collision") # TODO
    map1(state.objects, "update_destroy_timer", delta)
    map(state.objects, "queue_delete_bullet_on_collide") # TODO
    map(state.objects, "queue_delete_bullet_on_timeout")
    map1(state.objects, "spawn_bullet_particles_on_delete", self)
    fold(state.objects, "delete_object", state.objects)
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
    var duplicate = array.duplicate()
    for i in range(duplicate.size()):
        if func_name in duplicate[i]:
            accumulator = duplicate[i][func_name].call_func(duplicate[i], accumulator)
    return accumulator

func fold1(array: Array, func_name: String, accumulator, arg):
    var duplicate = array.duplicate()
    for i in range(duplicate.size()):
        if func_name in duplicate[i]:
            accumulator = duplicate[i][func_name].call_func(duplicate[i], accumulator, arg)
    return accumulator
