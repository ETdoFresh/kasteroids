class_name StateRecord
extends Record

var tick: int
var objects: ObjectsRecord

func _init(init_tick: int, init_objects: ObjectsRecord):
    tick = init_tick
    objects = init_objects

func copy():
    return get_script().new(tick, objects)
