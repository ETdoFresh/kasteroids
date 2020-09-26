class_name CollisionShape2DConvexPolygonRecord
extends CollisionShape2DRecord

var points: Array

func init(array: Array):
    var init = duplicate()
    for item in array:
        init.points.append(Vector2Record.new().init(item))
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.points = points
    return duplicate
