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
    
    var list = parse_json(serialized)
    for item in list:
        item.tick = int(item.tick)
        if not received_inputs.has(item.tick):
            received_inputs[item.tick] = item

        if item.tick > latest_received_tick:
            latest_received_tick = item.tick
            latest_received_time = time

func set_state_at_tick(tick):
    if not received_inputs.has(tick):
        return false
    else:
        horizontal = received_inputs[tick].horizontal
        vertical = received_inputs[tick].vertical
        fire = received_inputs[tick].fire
        return true
