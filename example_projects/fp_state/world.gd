extends Node2D

const STATE = preload("res://example_projects/fp_state/state.gd")

var state: STATE = STATE.new()

func _ready():
    state.tick = 0
    state.objects = get_children()
    map(state.objects, "randomize_linear_velocity")
    map(state.objects, "randomize_angular_velocity")
    map(state.objects, "randomize_scale")

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
    map(state.objects, "update_bounding_box")
    map1(state.objects, "broad_phase_collision_detection", state.objects)
    map1(state.objects, "narrow_phase_collision_detection", state.objects)
    map(state.objects, "resolve_collision")
    map1(state.objects, "update_destroy_timer", delta)
    map(state.objects, "queue_delete_bullet_on_collide")
    map(state.objects, "queue_delete_bullet_on_timeout")
    map1(state.objects, "spawn_bullet_particles_on_delete", self)
    map1(state.objects, "play_spawn_sound", self)
    map1(state.objects, "play_collision_sound", self)
    fold(state.objects, "delete_object", state.objects)
    map(state.objects, "clear_spawn")
    map(state.objects, "clear_collision")
    $Label.text = "FPS: %s" % Engine.get_frames_per_second()
    $Label.text += "\nObjects: %s" % state.objects.size()
    update()

func _draw():
    map1(state.objects, "draw_debug_bounding_box", self)
    pass

func connect_new_input(input):
    var ship = input.new_ship()
    ship.input = input
    state.objects.append(ship)

func disconnect_input(input):
    map1(state.objects, "queue_delete_input", input)
    map(state.objects, "delete_object")

func map(array: Array, func_name: String): ArrayFunc.map(array, func_name)
func map1(array: Array, func_name: String, arg): ArrayFunc.map1(array, func_name, arg)
func fold(array: Array, func_name: String, accumulator): ArrayFunc.fold(array, func_name, accumulator)
func fold1(array: Array, func_name: String, accumulator, arg): ArrayFunc.fold1(array, func_name, accumulator, arg)
