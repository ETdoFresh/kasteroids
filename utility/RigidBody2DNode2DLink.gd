extends RigidBody2D

class_name RigidBody2DNode2DLink

export (NodePath) var link_path

var link
var previous_position
var previous_rotation
var previous_scale

func _ready():
    if has_node(link_path):
        link = get_node(link_path)
    else:
        link = get_parent()
    
    previous_position = link.global_position
    previous_rotation = link.global_rotation

func _process(_delta):
    if previous_position != link.global_position:
        sleeping = false
    if previous_rotation != link.global_rotation:
        sleeping = false
    if previous_scale != link.global_scale:
        for child in get_children():
            if child is Node2D:
                if not child.has_meta("physics_original_scale"):
                    child.set_meta("physics_original_scale", child.scale)
                child.scale = child.get_meta("physics_original_scale") * link.global_scale
        sleeping = false
        previous_scale = scale

func _integrate_forces(state):
    var transform = state.get_transform()
        
    if previous_position != link.global_position \
    || previous_rotation != link.global_rotation:
        transform.origin = Vector2(0,0)
        transform = transform.rotated(-transform.get_rotation())
        transform = transform.rotated(link.global_rotation)
        transform.origin = link.global_position
        state.set_transform(transform)
        
    else:
        link.global_position = transform.get_origin()
        link.global_rotation = transform.get_rotation()
        
    previous_position = link.global_position
    previous_rotation = link.global_rotation
