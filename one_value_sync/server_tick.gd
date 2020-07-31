extends Node

var rtt_window = SlidingWindow.new(5)
var rtt = -1
var delay = -1
var prediction = -1
var last_received_server_tick = -1
var last_received_server_time = -1
var client_tick_sent_times = {}
var time = 0
var tick_rate = 1.0 / Engine.iterations_per_second

func _process(delta):
    time += delta
    update_server_tick()

func calculate_rtt(client_tick, offset_time):
    if client_tick == 0:
        return
    if not client_tick_sent_times.has(client_tick):
        return
    
    var client_tick_sent_time = client_tick_sent_times[client_tick]
    rtt = rtt_window.add(time - client_tick_sent_time  - offset_time)
    delay = rtt / 2

func record_client_recieve(server_tick, client_tick, offset_time):
    if server_tick <= last_received_server_tick:
        return
    
    last_received_server_tick = server_tick
    last_received_server_time = time
    calculate_rtt(client_tick, offset_time)

func record_client_send(client_tick):
    client_tick_sent_times[client_tick] = time

func update_server_tick():
    prediction = last_received_server_tick
    prediction += (time - last_received_server_time) / tick_rate
    prediction += delay / tick_rate
