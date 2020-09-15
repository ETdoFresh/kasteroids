extends Node2D

const COLLISION = CollisionFunctions
const SHORTCUT = ShortcutFunctions
const STATE = StateFunctions

var current_state

onready var label = $Label

func _ready():
    current_state = STATE.initial_state(get_children())

func _physics_process(delta : float):
    current_state = STATE.simulate(current_state, delta, self)
    #current_state.objects = COLLISION.add_collision_markers(current_state.objects, self)
    #label.text = JSONBeautifier.beautify_json(to_json(current_state))
    label.text = "FPS: %s\nOBJECTS: %s" % [Engine.get_frames_per_second(), current_state.objects.size()]

func _input(event):
    SHORTCUT.receive_input(event, self)
