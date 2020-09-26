class_name StateRecord
extends Record

var tick: int
var objects: ObjectsRecord

func init(init_tick: int, init_objects: ObjectsRecord):
    var init = duplicate()
    init.tick = init_tick
    init.objects = init_objects
    return init
