class_name IntRecord
extends Record

var value: int

func init(init_value: int):
    var init = duplicate()
    init.value = init_value
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.value = value
    return duplicate
