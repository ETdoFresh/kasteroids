extends Node

class_name Wrap

export (NodePath) var transform_path

var transform
var screen_size

func _ready():
    var transform_node = get_node(transform_path)
    transform = transform_node if transform_node else get_parent()
    screen_size = get_viewport().get_visible_rect().size 

#warning-ignore:unused_argument
func _physics_process(delta):
    wrap()

func wrap():
    var position = transform.position
    while position.x < 0:
        position.x += screen_size.x
    while position.x > screen_size.x:
        position.x -= screen_size.x
    while position.y < 0:
        position.y += screen_size.y
    while position.y > screen_size.y:
        position.y -= screen_size.y
    
    if position != transform.position:
        transform.position = position
