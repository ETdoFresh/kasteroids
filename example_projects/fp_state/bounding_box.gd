class_name BoundingBox

var position = Vector2.ZERO
var extents = Vector2.ZERO

func _init(init_position: Vector2, init_extents: Vector2):
    position = init_position
    extents = init_extents

func get_left(): return position.x - extents.x
func get_right(): return position.x + extents.x
func get_top(): return position.y - extents.y
func get_bottom(): return position.y + extents.y

func expand(point: Vector2):
    var left = get_left()
    var right = get_right()
    var top = get_top()
    var bottom = get_bottom()
    if left > point.x:
        left = point.x
    if right < point.x:
        right = point.x
    if top > point.y:
        top = point.y
    if bottom < point.y:
        bottom = point.y
    
    var expanded = get_script().new(position, extents)
    expanded.extents.x = (right - left) / 2
    expanded.extents.y = (bottom - top) / 2
    expanded.position.x = left + extents.x
    expanded.position.y = top + extents.y
    return expanded

func has_point(point: Vector2):
    if point.x < get_left(): return false
    if point.x > get_right(): return false
    if point.y < get_top(): return false
    if point.y > get_bottom(): return false
    return true

func intersects(other_bounding_box: BoundingBox):
    if other_bounding_box.get_right() < get_left(): return false
    if other_bounding_box.get_left() > get_right(): return false
    if other_bounding_box.get_bottom() < get_top(): return false
    if other_bounding_box.get_top() > get_bottom(): return false
    return true
