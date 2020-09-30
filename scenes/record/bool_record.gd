class_name BoolRecord
extends Record

var value: bool

func init(init_value: bool):
    return set_value(init_value)

func set_value(set_value: bool):
    var duplicate = duplicate()
    duplicate.value = set_value
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
