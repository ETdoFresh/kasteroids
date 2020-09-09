extends Node2D

const list = preload("res://list.gd")
const dictionary = preload("res://dictionary.gd")
const physics = preload("res://physics.gd")
const input = preload("res://input.gd")
const node = preload("res://node.gd")
const wrap = preload("res://wrap.gd")

onready var current_state = empty_state()
onready var label = $Label

func _ready():
    current_state.objects = list.map(get_children(), funcref(node, "to_object"))
    return

func _physics_process(_delta : float):
    #if Input.is_action_just_pressed("ui_accept"): # Step simulation using spacebar
    current_state = simulate(current_state, 1.0/60)
    label.text = JSONBeautifier.beautify_json(to_json(current_state))

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": []}

static func simulate(state : Dictionary, delta : float) -> Dictionary:
    state = dictionary.update(state, "tick", state.tick + 1)
    state.objects = list.map(state.objects, funcref(input, "apply"))
    state.objects = list.map1(state.objects, funcref(physics, "move"), delta)
    state.objects = list.map(state.objects, funcref(wrap, "wrap"))
    state.objects = list.map(state.objects, funcref(node, "from_object"))
    return state
