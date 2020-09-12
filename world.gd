extends Node2D

const SHORTCUT = ShortcutFunctions
const STATE = StateFunctions

var current_state

onready var label = $Label

func _ready():
    current_state = STATE.initial_state(get_children())

func _physics_process(delta : float):
    current_state = STATE.simulate(current_state, delta)
    label.text = JSONBeautifier.beautify_json(to_json(current_state))

func _input(event):
    SHORTCUT.receive_input(event, self)
