class_name CollisionShape2DConvexPolygonRecord
extends CollisionShape2DRecord

var points: Array

func _init(array: Array):
    for item in array:
        points.append(Vector2Record.new(item))
