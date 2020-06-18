extends Node

func _process(_delta):
    Util.copy_input_variables($Input, $World)
