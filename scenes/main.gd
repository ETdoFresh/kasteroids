extends Node

func _ready():
    $World.create_player($Input)
