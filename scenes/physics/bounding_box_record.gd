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
        var extents_vector2 = get_extents_from_points(init_collision_shape_record.points)
        init.extents = ExtentsRecord.new().init(extents_vector2)
        return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.position = position
    duplicate.extents = extents
    return duplicate

func get_extents_from_points(points: Array):
    var extents_vector2 = Vector2.ZERO
    for point in points:
        if extents_vector2.x < abs(point.x):
            extents_vector2.x = abs(point.x)
        if extents_vector2.y < abs(point.y):
            extents_vector2.y = abs(point.y)
    return extents_vector2

func get_left(): return position.value.x - extents.value.x
func get_right(): return position.value.x + extents.value.x
func get_top(): return position.value.y - extents.value.y
func get_bottom(): return position.value.y + extents.value.y
