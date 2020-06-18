class_name Wrap
extends Node

onready var screen_size = get_viewport().get_visible_rect().size 

func wrap(state):
    var transform = state.transform
    var position = transform.origin
    while position.x < 0:
        position.x += screen_size.x
    while position.x > screen_size.x:
        position.x -= screen_size.x
    while position.y < 0:
        position.y += screen_size.y
    while position.y > screen_size.y:
        position.y -= screen_size.y
    
    if transform.origin != position:
        transform.origin = position
        state.set_transform(transform)
