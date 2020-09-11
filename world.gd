extends Node2D

const ASTEROID = AsteroidFunctions
const DICTIONARY = DictionaryFunctions
const LIST = ListFunctions
const NODE = NodeFunctions
const PHYSICS = PhysicsFunctions
const SHIP = ShipFunctions
const SOUND = SoundFunctions
const WRAP = WrapFunctions

onready var current_state = empty_state()
onready var label = $Label

func _ready():
    var state = current_state
    state.objects = LIST.map(get_children(), funcref(NODE, "to_dictionary"))
    state.objects = LIST.filtered_map(state.objects, funcref(ASTEROID, "is_asteroid"), funcref(ASTEROID, "randomize_angular_velocity"))
    state.objects = LIST.filtered_map(state.objects, funcref(ASTEROID, "is_asteroid"), funcref(ASTEROID, "randomize_linear_velocity"))
    state.objects = LIST.filtered_map(state.objects, funcref(ASTEROID, "is_asteroid"), funcref(ASTEROID, "randomize_scale"))
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display"))
    #state.objects = LIST.map(state.objects, funcref(PHYSICS, "create_physical_object"))

func _physics_process(delta : float):
    #if Input.is_action_just_pressed("ui_accept"): # Step simulation using spacebar
    current_state = simulate(current_state, delta)
    label.text = JSONBeautifier.beautify_json(to_json(current_state))

func _input(event):
    if Input.is_key_pressed(KEY_CONTROL):
        if event is InputEventKey:
            if event.is_pressed():
                if event.scancode == KEY_R:
                    var _1 = get_tree().reload_current_scene()

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": []}

static func simulate(state : Dictionary, delta : float) -> Dictionary:
    state = DICTIONARY.update(state, "tick", state.tick + 1)
    state.objects = LIST.filtered_map1(state.objects, funcref(SHIP, "is_ship"), funcref(SHIP, "apply_input"), delta)
    state.objects = LIST.filtered_map(state.objects, funcref(SHIP, "is_ship"), funcref(SHIP, "limit_speed"))
    state.objects = LIST.map1(state.objects, funcref(PHYSICS, "move_and_collide"), delta)
    state.objects = PHYSICS.add_collisions_to_other_colliders(state.objects)
    state.objects = LIST.filtered_map(state.objects, funcref(PHYSICS, "has_collided"), funcref(SOUND, "play_collision_sound"))
    state.objects = PHYSICS.resolve_collisions(state.objects)
    state.objects = LIST.map(state.objects, funcref(WRAP, "wrap"))
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display"))
    return state
