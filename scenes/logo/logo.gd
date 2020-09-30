extends Control

func _ready():
    var _1 = $Timer.connect("timeout", Game, "load_menu_scene")
