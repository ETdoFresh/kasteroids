class_name NetworkServerPlayerInput
extends Node

var client
var input_name
var received_inputs = {}
var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false
var latest_received_tick = -1
var latest_received_time = -1
var time = 0
var misses = 0

func _init(init_name_prefix, init_client):
    input_name = init_name_prefix + " " + String(randi() % 10000)
    client = init_client

func _process(delta):
    time += delta

func deserialize(from_client, serialized):
    if from_client != client: return
    
    for message in serialized.split("|", false):
        var items = serialized.split(",", false)
        var tick = int(items[0])
        if not received_inputs.has(tick):
            received_inputs[tick] = {
                "horizontal": float(items[1]),
                "vertical": float(items[2]),
                "fire": true if items[3] == "True" else false
            }
        if tick > latest_received_tick:
            latest_received_tick = tick
            latest_received_time = time

func set_state_at_tick(tick):
    if not received_inputs.has(tick):
        return false
    else:
        horizontal = received_inputs[tick].horizontal
        vertical = received_inputs[tick].vertical
        fire = received_inputs[tick].fire
        return true
