class_name StringRecord
extends Record

var value: String

func init(init_value: String):
    return set_value(init_value)

func set_value(set_value: String):
    var duplicate = duplicate()
    duplicate.value = set_value
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
