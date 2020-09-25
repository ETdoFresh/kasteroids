extends Node2D

var state

onready var label = $Label

func _ready():
    state = FP.World.init(self)

func _physics_process(_delta : float):
    state = FP.World.process(state, _delta, self)
    #current_state = StateFunctions.simulate(current_state, delta, self)
    #current_state.objects = CollisionFunctions.add_collision_markers(current_state.objects, self)
    #label.text = JSONBeautifier.beautify_json(to_json(current_state))
    #label.text = "FPS: %s\nOBJECTS: %s" % [Engine.get_frames_per_second(), current_state.objects.size()]
    pass

func _input(event):
    ShortcutFunctions.receive_input(event, self)
