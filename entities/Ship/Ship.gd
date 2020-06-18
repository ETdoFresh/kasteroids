class_name Ship
extends BaseNode2D

signal create(scene, position, rotation, rigidbody, velocity_magnitude)

var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false

onready var state_machine = $States

func state_name():
    return state_machine.active_state_name

func _process(_delta):
    var state = state_machine.active_state
    if state:
        Util.copy_input_variables(self, state)
        
        if fire:
            if state.has_node("CollisionShape2D/Gun"):
                var gun = state.get_node("CollisionShape2D/Gun")
                gun.fire(self, state)
    
    # Just some DEBUG code to test different states...
    if previous_state:
        state_machine.set_previous_state()
    elif next_state:
        state_machine.set_next_state()
