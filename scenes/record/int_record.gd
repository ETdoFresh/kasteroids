class_name IntRecord
extends Record

var value: int

func init(init_value: int):
    return set_value(init_value)

func set_value(set_value: int):
    var duplicate = duplicate()
    duplicate.value = set_value
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
