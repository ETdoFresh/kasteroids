class_name FloatRecord
extends Record

var value: float

func init(init_value: float):
    return set_value(init_value)

func set_value(set_value: float):
    var duplicate = duplicate()
    duplicate.value = set_value
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
