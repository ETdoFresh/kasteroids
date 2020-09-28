class_name BoolRecord
extends Record

var value: bool

func init(init_value: bool):
    var init = duplicate()
    init.value = init_value
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
