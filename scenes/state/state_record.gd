class_name StateRecord
extends Record

var tick: int
var objects: ObjectsRecord

func init(init_tick: int, init_objects: ObjectsRecord):
    var init = duplicate()
    init.tick = init_tick
    init.objects = init_objects
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.tick = tick
    duplicate.objects = objects
    return duplicate
