extends Node

class_name Wrap

onready var parent = get_parent()
onready var screen_size = get_viewport().get_visible_rect().size

#warning-ignore:unused_argument
func _physics_process(delta):
    wrap()

func wrap():
    var position = parent.position
    while position.x < 0:
        position.x += screen_size.x
    while position.x > screen_size.x:
        position.x -= screen_size.x
    while position.y < 0:
        position.y += screen_size.y
    while position.y > screen_size.y:
        position.y -= screen_size.y
    
    if position != parent.position:
        parent.set_position(position)
