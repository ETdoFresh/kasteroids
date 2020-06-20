class_name LatencySimulator
extends Node

export var simulate_latency = true
export var min_latency = 0.100
export var max_latency = 0.300
export var drop_rate = 0.10
export var dup_rate = 0.05
export var out_of_order = true

var queue = []

func _process(delta):
    while not queue.empty():
        var now = OS.get_ticks_msec() / 1000.0
        if now < queue[0][0]: break
        var data = queue.pop_front()
        var client = data[1]
        var message = data[2].to_ascii()
        client.put_data(message)

func send(client, message):
    if not simulate_latency:
        queue.push_back([0, client, message])
        return
        
    if randf() < drop_rate: return

    var now = OS.get_ticks_msec() / 1000.0
    var duration = 0
    if max_latency > 0:
        duration = now + min_latency + randf() * (max_latency - min_latency)

    queue.push_back([duration, client, message])

    while randf() < dup_rate:
        var duplicate_duration = now + min_latency + randf() * (max_latency - min_latency)
        queue.push_back([duplicate_duration, client, message])

    if out_of_order:
        queue.sort_custom(self, "sort_duration")

func sort_duration(a, b):
    return a[0] < b[0]
