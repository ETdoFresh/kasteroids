class_name BoundingBoxRecord
extends Record

var position: PositionRecord
var extents: ExtentsRecord

func init(init_position: Vector2, init_collision_shape_record: CollisionShape2DRecord):
    var init = duplicate()
    init.position = PositionRecord.new().init(init_position)
    if init_collision_shape_record is CollisionShape2DCircleRecord:
        var radius = init_collision_shape_record.radius
        init.extents = ExtentsRecord.new().init(Vector2(radius, radius))
        return init
    elif init_collision_shape_record is CollisionShape2DConvexPolygonRecord:
        var extents = get_extents_from_points(init_collision_shape_record.points)
        init.extents = extents
        return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.position = position
    duplicate.extents = extents
    return extents

func get_extents_from_points(points: Array):
    var extents = Vector2.ZERO
    for point in points:
        if extents.x < abs(point.x):
            extents.x = abs(point.x)
        if extents.y < abs(point.y):
            extents.y = abs(point.y)
    return extents
