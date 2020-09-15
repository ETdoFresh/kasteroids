class_name BoundingBoxFunctions

const COLLISION = CollisionFunctions

static func set_bounding_box(object: Dictionary) -> Dictionary:
    if not COLLISION.has_shapes(object): return object
    object = object.duplicate()
    var bounding_box = Rect2(object.position, Vector2.ONE)
    for collision_shape_2d in object.node.collision_shapes_2d:
        bounding_box = _encapsulate(bounding_box, collision_shape_2d)
    object["bounding_box"] = bounding_box
    return object

static func _encapsulate(rect: Rect2, collision_shape_2d: CollisionShape2D) -> Rect2:
    var position = collision_shape_2d.global_position
    var scale = collision_shape_2d.global_scale
    var shape = collision_shape_2d.shape
    if shape is CircleShape2D:
        var radius = shape.radius
        var min_pt = position - scale * radius
        var max_pt = position + scale * radius
        return rect.expand(min_pt).expand(max_pt)
    if shape is RectangleShape2D:
        var extents = shape.extents
        var min_pt = position - scale * extents
        var max_pt = position + scale * extents
        return rect.expand(min_pt).expand(max_pt)
    if shape is ConvexPolygonShape2D:
        for point in shape.points:
            rect = rect.expand(position + point)
        return rect
    else:
        return rect
