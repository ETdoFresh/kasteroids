class_name Vector2Record
extends Record

var x: float
var y: float
var vector2: Vector2 setget , get_vector2

func init(init_vector2: Vector2):
    var init = duplicate()
    init.x = init_vector2.x
    init.y = init_vector2.y
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.x = x
    duplicate.y = y
    return duplicate

func get_vector2():
    return Vector2(x, y)
