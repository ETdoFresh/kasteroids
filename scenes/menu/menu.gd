extends Node

func _ready():
    var _1 = $Button.connect("pressed", Game, "load_single_player_level", [1])
