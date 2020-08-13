extends RigidBody2D

var queued_position = null
var queued_rotation = null

func _integrate_forces(state):
    if queued_position == null && queued_rotation == null:
        return
    
    var transform = state.transform
    var position = queued_position if queued_position != null else transform.get_origin()
    var rotation = queued_rotation if queued_rotation != null else transform.get_rotation()
    
    queued_position = null
    queued_rotation = null
    
    if position == transform.get_origin() && rotation == transform.get_rotation():
        return
    
    transform = transform.translated(-transform.get_origin())
    transform = transform.rotated(-transform.get_rotation())
    transform = transform.rotated(rotation)
    transform.origin = position
    state.set_transform(transform)

func queue_position(position):
    queued_position = position

func queue_rotation(rotation):
    queued_rotation = rotation

func queue_scale(scale):
    $CollisionShape2D.scale = scale

func inverse(vector2 : Vector2):
    var x = 1 / vector2.x if vector2.x != 0.0 else 0.0
    var y = 1 / vector2.y if vector2.y != 0.0 else 0.0
    return Vector2(x, y)
