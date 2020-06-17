extends Node2D

class_name StateMachine

export var allow_transitions = true
export (String) var active_state_name

var states = []
var active_state

func _ready():
    for child in get_children():
        child.visible = true
        states.append(child)
        remove_child(child)
    
    if get_state_by_name(active_state_name) == null:
        active_state_name = states[0].name
    
    set_state_by_name(active_state_name)

func set_state(new_state):
    if not allow_transitions and active_state != null:
        return
    
    var previous_state = active_state
    if previous_state == new_state:
        return
    
    if previous_state:
        if previous_state.get_parent() == self: 
            remove_child(active_state)
        if (previous_state.has_method("state_exit")):
            previous_state.state_exit()
    
    active_state = new_state
    active_state_name = new_state.name
    add_child(new_state)
    if (new_state.has_method("state_enter")):
        new_state.state_enter(previous_state)

func set_state_by_name(name):
    var state = get_state_by_name(name)
    if state != null:
        set_state(state)

func get_state_by_name(name):
    for state in states:
        if state.name.to_lower() == name.to_lower():
            return state
    return null

var inspector_state_monitor = active_state_name
func _process(delta):
    if inspector_state_monitor != active_state_name:
        inspector_state_monitor = active_state_name
        set_state_by_name(active_state_name)
