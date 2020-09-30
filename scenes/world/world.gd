extends Node2D

var state

onready var label = $Label

func _ready():
    state = FP.world.ready(self)

func _process(_delta : float):
    state = FP.world.process(state, _delta, self)
    #current_state = StateFunctions.simulate(current_state, delta, self)
    #current_state.objects = CollisionFunctions.add_collision_markers(current_state.objects, self)
    #label.text = JSONBeautifier.beautify_json(to_json(current_state))
    label.text = "FPS: %s\nOBJECTS: %s" % [Engine.get_frames_per_second(), state.objects.array.size()]
    pass
