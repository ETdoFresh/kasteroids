extends Node

#signal tick

var rtt_window = SlidingWindow.new(1)
var rtt = 0
var delay = 0
var prediction = 0
var future_tick = 0
var last_received_server_tick = -1
var last_received_client_time = 0
var last_received_client_tick = 0
var client_tick_sent_times = {}
var time = 0
var tick_rate = 1.0 / Settings.ticks_per_second
var precise_smooth_tick = 0.0
var smooth_tick = 0
var buffer = 10
var smooth_tick_ahead_count = 0
var receive_rate_window = SlidingWindow.new(10)
var receive_rate = 0
var interpolated_tick = 0
var interpolation_rate = 0.1
var client_send_rate = 60

func _process(delta):
    time += delta
    update_server_tick()
    update_smooth_tick(delta)
    update_interpolated_tick()

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
    
    receive_rate = receive_rate_window.add(time - last_received_client_time)
    
    last_received_server_tick = server_tick
    last_received_client_time = time
    last_received_client_tick = client_tick
    calculate_rtt(client_tick, offset_time)

func record_client_send(client_tick):
    client_tick_sent_times[int(client_tick)] = time

func update_server_tick():
    prediction = last_received_server_tick
    prediction += (time - last_received_client_time) / tick_rate
    prediction += delay / tick_rate
    future_tick = prediction
    future_tick += rtt / tick_rate# * (Engine.iterations_per_second / client_send_rate) * 2

func update_smooth_tick(delta):
    # warning-ignore:integer_division
    if abs(precise_smooth_tick - future_tick) >= Settings.ticks_per_second / 2:
        precise_smooth_tick = round(future_tick) - 1
    
    precise_smooth_tick += 0.5 * delta * Settings.ticks_per_second
    
    if precise_smooth_tick > future_tick:
        pass
    elif precise_smooth_tick < future_tick:
        precise_smooth_tick += 1 * delta * Settings.ticks_per_second
    elif precise_smooth_tick == future_tick:
        precise_smooth_tick += 0.5 * delta * Settings.ticks_per_second
    
    smooth_tick = int(round(precise_smooth_tick))

func update_interpolated_tick():
    var target_iterpolation_rate = rtt # back to predicted_tick
    target_iterpolation_rate += max(rtt, receive_rate) * 1.5
    interpolation_rate = lerp(interpolation_rate, target_iterpolation_rate, 0.1)
    interpolated_tick = smooth_tick - interpolation_rate / tick_rate
