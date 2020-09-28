class_name CollisionPairRecord
extends Record

var record1: Record
var record2: Record
var collision: CollisionRecord

var can_collide: bool
var broad_phase_check: bool
var has_collided: bool # narrow_phase_check

func init(init_record1: Record, init_record2: Record):
    var init = duplicate()
    init.record1 = init_record1
    init.record2 = init_record2
    return init

func reset():
    var reset = duplicate()
    reset.record1 = null
    reset.record2 = null
    reset.collisionRecord = null
    reset.can_collide = false
    reset.broad_phase_check = false
    reset.has_collided = false
    return reset

func duplicate():
    var duplicate = get_script().new()
    duplicate.record1 = record1
    duplicate.record2 = record2
    duplicate.collision = collision
    duplicate.can_collide = can_collide
    duplicate.broad_phase_check = broad_phase_check
    duplicate.has_collided = has_collided
    return duplicate
