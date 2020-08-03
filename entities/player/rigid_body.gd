extends RigidBody2D

var queued_position = null
var queued_rotation = null

func _integrate_forces(state):
    if queued_position != null:
        state.transform.origin = queued_position
    
    if queued_rotation != null:
        var position = state.transform.origin
        transform.origin = Vector2(0,0)
        transform = transform.rotated(-transform.get_rotation())
        transform = transform.rotated(queued_rotation)
        transform.origin = position
    
    if queued_position != null || queued_rotation != null:
        state.set_transform(transform)
    
    queued_position = null
    queued_rotation = null

func queue_position(position):
    self.position = position
    queued_position = position

func queue_rotation(rotation):
    self.rotation = rotation
    queued_rotation = rotation
