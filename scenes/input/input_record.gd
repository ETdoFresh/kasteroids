class_name InputRecord
extends Record

var horizontal: float
var vertical: float
var fire: bool

func init(init_horizontal: float, init_vertical: float, init_fire: bool):
    var init = duplicate()
    init.horizontal = init_horizontal
    init.vertical = init_vertical
    init.fire = init_fire
    return init
