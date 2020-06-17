extends Node2D

func _ready():
    $Keyboard.connect("connected", $World, "add_player")
    $Keyboard.connect("disconnected", $World, "remove_player")
