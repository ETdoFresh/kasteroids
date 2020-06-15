extends RigidBody2D

class_name RigidBody2DExt

export var use_initial_scale_for_scaling = true

var rigid_body_2D_scale setget set_scale, get_scale
var new_position
var new_rotation
var position_changed = false
var rotation_changed = false

func set_position(new_position):
    position_changed = true
    self.new_position = new_position

func set_rotation(new_rotation):
    rotation_changed = true
    self.new_rotation = new_rotation

func get_scale():
    if rigid_body_2D_scale:
        return rigid_body_2D_scale
    elif has_node("Sprite"):
        return get_node("Sprite").scale
    else:
        return scale

func set_scale(new_scale):
    rigid_body_2D_scale = new_scale
    for child in self.get_children():
        if not child is Node2D:
            continue
        if not child.has_meta("original_scale"):
            if use_initial_scale_for_scaling:
                child.set_meta("original_scale",child.get_scale())
            else:
                child.set_meta("original_scale",Vector2(1,1))
        var original_scale = child.get_meta("original_scale")
        child.set_scale(original_scale * new_scale)

func _integrate_forces(state):
    if not position_changed && not rotation_changed:
        return
    
    var transform = state.get_transform()
    if position_changed:
        transform.origin = new_position
        position_changed = false
    if rotation_changed:
        transform = transform.rotated(-rotation).rotated(new_rotation)
        rotation_changed = false
    state.set_transform(transform)
