class_name TCPServerInput
extends Node

var client
var input_name = "TCP Input"
var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false

func deserialize(from_client, serialized):
    if from_client != client: return
    
    var items = serialized.split(",", false)
    horizontal = float(items[0])
    vertical = float(items[1])
    fire = true if items[2] == "True" else false
