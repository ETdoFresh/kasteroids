extends Node

class_name Wrap

var screen_size

func _ready():
    screen_size = get_viewport().get_visible_rect().size
    
func _on_integrate_forces(state):
    wrap(state)
    
func wrap(state):
    var transform = state.get_transform()
    var position = transform.origin
    while position.x < 0:
        position.x += screen_size.x
    while position.x > screen_size.x:
        position.x -= screen_size.x
    while position.y < 0:
        position.y += screen_size.y
    while position.y > screen_size.y:
        position.y -= screen_size.y
    
    if position != transform.origin:
        transform.origin = position
        state.set_transform(transform)
