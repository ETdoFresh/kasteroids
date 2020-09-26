class_name CollisionShape2DCircleRecord
extends CollisionShape2DRecord

var radius: float

func init(init_radius: float):
    var init = duplicate()
    init.radius = init_radius
    return init
