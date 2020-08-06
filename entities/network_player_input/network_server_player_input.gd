class_name NetworkServerPlayerInput
extends Node

var client
var input_name
var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false

func _init(init_name_prefix, init_client):
    input_name = init_name_prefix + " " + String(randi() % 10000)
    client = init_client

func deserialize(from_client, serialized):
    if from_client != client: return
    
    var items = serialized.split(",", false)
    horizontal = float(items[0])
    vertical = float(items[1])
    fire = true if items[2] == "True" else false
