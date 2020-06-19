extends Node

func _enter_tree():
    $Inputs.connect("node_added", self, "input_connected")
    $Inputs.connect("node_removed", self, "input_disconnected")
    
func input_connected(input):
    $World.create_player(input)

func input_disconnected(input):
    $World.delete_player(input)
