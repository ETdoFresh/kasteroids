extends RigidBody2D

var queued_position = null
var queued_rotation = null
var queued_scale = null

func _integrate_forces(state):
    if queued_position == null && queued_rotation == null || queued_scale == null:
        return
    
    var transform = state.transform
    var position = queued_position if queued_position != null else transform.get_origin()
    var rotation = queued_rotation if queued_rotation != null else transform.get_rotation()
    var scale = queued_scale if queued_scale != null else transform.get_scale()
    
    queued_position = null
    queued_rotation = null
    queued_scale = null
    
    if position == transform.get_origin() && rotation == transform.get_rotation() && scale == transform.get_scale():
        return
    
    transform = transform.translated(-transform.get_origin())
    transform = transform.rotated(-transform.get_rotation())
    transform = transform.scaled(inverse(transform.get_scale()))
    transform = transform.scaled(scale)
    transform = transform.rotated(rotation)
    transform.origin = position
    state.set_transform(transform)

func queue_position(position):
    self.position = position
    queued_position = position
    self.sleeping = false

func queue_rotation(rotation):
    self.rotation = rotation
    queued_rotation = rotation

func queue_scale(scale):
    self.scale = scale
    queued_scale = scale

func inverse(vector2 : Vector2):
    var x = 1 / vector2.x if vector2.x != 0.0 else 0.0
    var y = 1 / vector2.y if vector2.y != 0.0 else 0.0
    return Vector2(x, y)
