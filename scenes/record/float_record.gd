class_name FloatRecord
extends Record

var value: float

func init(init_value: float):
    var init = duplicate()
    init.value = init_value
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
