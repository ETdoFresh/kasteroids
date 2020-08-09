extends Node

signal tick

var rtt_window = SlidingWindow.new(5)
var rtt = -1
var delay = -1
var prediction = -1
var future_tick = -1
var last_received_server_tick = -1
var last_received_server_time = -1
var client_tick_sent_times = {}
var time = 0
var smooth_tick = -1
var smooth_tick_rounded = -1
var smooth_tick_smooth_rate = 0.5
var buffer = 10
var smooth_tick_ahead_count = 0

func _process(delta):
    time += delta
    update_server_tick()
    update_smooth_tick(delta)

func calculate_rtt(client_tick, offset_time):
    if client_tick == 0:
        return
    if not client_tick_sent_times.has(client_tick):
        return
    
    var client_tick_sent_time = client_tick_sent_times[client_tick]
    rtt = rtt_window.add(time - client_tick_sent_time  - offset_time)
    delay = rtt / 2
    
    for i in range(client_tick_sent_times.size() - 1, -1, -1):
        if client_tick_sent_times.keys()[i] < client_tick:
            client_tick_sent_times.erase(client_tick_sent_times.keys()[i])

func record_client_recieve(server_tick, client_tick, offset_time):
    if server_tick <= last_received_server_tick:
        return
    
    last_received_server_tick = server_tick
    last_received_server_time = time
    calculate_rtt(client_tick, offset_time)

func record_client_send(client_tick):
    client_tick_sent_times[int(client_tick)] = time

func update_server_tick():
    prediction = last_received_server_tick
    prediction += (time - last_received_server_time) * Settings.ticks_per_second
    prediction += delay * Settings.ticks_per_second
    future_tick = prediction
    future_tick += rtt * Settings.ticks_per_second

func update_smooth_tick(delta):
    var previous_smooth_tick_rounded = smooth_tick_rounded
    if future_tick - smooth_tick >= Settings.ticks_per_second:
        smooth_tick = future_tick
        previous_smooth_tick_rounded = int(round(smooth_tick))
    
    var rate = future_tick - smooth_tick
    if rate < 0: rate = future_tick / (smooth_tick + rate * rate * Settings.ticks_per_second)
    else: rate = 1 + rate * 0.25
    
    smooth_tick += rate * delta * Settings.ticks_per_second
    smooth_tick_rounded = int(round(smooth_tick))
    for _i in range(previous_smooth_tick_rounded + 1, smooth_tick_rounded + 1):
        emit_signal("tick")
