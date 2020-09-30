class_name InputRecord
extends Record

var horizontal: float
var vertical: float
var fire: bool

func init(init_horizontal: float, init_vertical: float, init_fire: bool):
    return set_input(init_horizontal, init_vertical, init_fire)

func set_input(set_horizontal: float, set_vertical: float, set_fire: bool):
    var duplicate = duplicate()
    duplicate.horizontal = set_horizontal
    duplicate.vertical = set_vertical
    duplicate.fire = set_fire
    return duplicate

func duplicate():
    var duplicate = get_script().new()
    duplicate.horizontal = horizontal
    duplicate.vertical = vertical
    duplicate.fire = fire
    return duplicate
