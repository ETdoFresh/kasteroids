extends Node

class_name NetworkConnection

signal on_open(client)
signal on_close(client)
signal on_receive(client, message)
signal on_send(client, message)

export var min_latency = 0.100
export var max_latency = 0.300
export var drop_rate = 0.10
export var dup_rate = 0.05
export var out_of_order = true
var queue = []

func _init():
    randomize()

func _process(delta):
    var message = receive()
    if (message != null):
        emit_signal("on_receive", null, message)

func listen(url):
    pass

func open(url):
    pass

func send(client, message):
    
    if randf() < drop_rate: return
    
    var t = OS.get_ticks_msec() / 1000.0
    
    var duration = 0
    if max_latency > 0:
        duration = t + min_latency + randf() * (max_latency - min_latency)
    
    queue.push_back([duration, message])
    
    while randf() < dup_rate:
        var duplicate_duration = t + min_latency + randf() * (max_latency - min_latency)
        queue.push_back([duplicate_duration, message])
    
    if out_of_order:
        queue.sort_custom(self, "sort_duration")
        
    emit_signal("on_send", client, message)

func sort_duration(a, b):
    return a[0] < b[0]

func receive():
    
    if queue.empty(): return null
    
    var t = OS.get_ticks_msec() / 1000.0
    if t < queue[0][0]:
        return null
    return queue.pop_front()[1]
