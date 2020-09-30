class_name Vector2Record
extends Record

var x: float
var y: float
var value: Vector2 setget , get_vector2

func init(init_value: Vector2):
    return set_value(init_value)

func set_value(set_value: Vector2):
    var duplicate = duplicate()
    duplicate.x = set_value.x
    duplicate.y = set_value.y
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.x = x
    duplicate.y = y
    return duplicate

func get_vector2():
    return Vector2(x, y)
