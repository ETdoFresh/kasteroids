class_name CollisionRecord
extends PossibleCollisionRecord

var other: Record
var position: PositionRecord
var normal: NormalRecord
#var remainder: Vector2Record
#var travel: Vector2Record

func init(init_other, init_position, init_normal):
    var init = duplicate()
    other = init_other
    position = init_position
    normal = init_normal
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.other = other
    duplicate.position = position
    duplicate.normal = normal
    return duplicate
