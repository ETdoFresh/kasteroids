extends Node

export var paused = false
export var time_scale = 0.1

var server
var client

var packet = \
{
    "tick": 0,
    "tick_rate": 0,
    "last_received_tick": 0,
    "time_since_last_received": 0.0
}
# How to compute latency:
# 1. Client sends packet with client_tick at client_sent_time[client_tick]
# 2. Server receives client_tick
# 3. Server has to wait until its time to send again [time_since_last_received]
# 4. Server sends client_tick back to client
# 5. Client received client_tick and time_since_last_received
# 6. round_trip_time = time - client_sent_time[client_tick]
# 7. It's impoorant to consider the server had to wait, so
#    round_trip_time = time - client_sent_time[client_tick] - time_since_last_received
# 8. latency = round_trip_time / 2

func _ready():
    randomize()
    reset()
    $Server/TCP.connect("on_receive", self, "on_server_receive")
    $Server/TCP.listen()
    
func _process(delta):
    if Input.is_action_just_pressed("clock_test_reset"):
        reset()
    if Input.is_action_just_pressed("clock_test_pause"):
        paused = not paused
    if Input.is_action_just_pressed("clock_test_connect"):
        client.is_running = true
        $Client/TCP.connect("on_open", self, "on_client_connect")
        $Client/TCP.connect("on_close", self, "on_client_disconnect")
        $Client/TCP.connect("on_receive", self, "on_client_receive")
        $Client/TCP.open()
    if paused:
        return
    
    delta *= time_scale
    server_tick(delta)
    client_tick(delta)
    adjust_client_tick_rate()
    display_variables()
    send_data(server)
    send_data(client)

func reset():
    $Client/TCP.close()
    $Server/History.clear()
    $Client/History.clear()
    server = \
    {
        "tick": 100,
        "tick_time": 0.0,
        "tick_rate": 30,
        "time": 0,
        "last_received_tick": 0,
        "last_received_time": 0.0,
        "last_sent_time": 0.0,
        "send_rate": 30,
        "rtt": 0.0,
        "latency": 0.0,
        "rtt_window": [],
        "rtt_window_size": 10,
        "is_running": true,
        "send_history": [],
        "receive_history": [],
        "input_misses": 0
    }
    
    client = \
    {
        "tick": 0,
        "tick_time": 0.0,
        "tick_rate": 5,
        "time": 0,
        "server_tick": 0,
        "server_tick_rate": 0,
        "target_tick": 0,
        "last_received_tick": 0,
        "last_received_time": 0.0,
        "last_sent_time": 0.0,
        "send_rate": 30,
        "rtt": 0.0,
        "latency": 0.0,
        "rtt_window": [],
        "rtt_window_size": 10,
        "computer_speed": 1.0 + 0.5 * randf() - 0.25,
        "is_running": false,
        "is_connected": false,
        "send_history": [],
        "receive_history": [],
    }

func server_tick(delta):
    if not server.is_running: return
    server.time += delta
    if server.tick_rate == 0: return
    if server.is_running: server.tick_time += delta    
    var time_to_tick = 1.0 / server.tick_rate
    while server.tick_time >= time_to_tick:
        server.tick_time -= time_to_tick
        server.tick += 1
        if $Server/TCP.clients.size() > 0 && not $Server/History.get_received_from_tick(server.tick):
            server.input_misses += 1

func client_tick(delta):
    if not client.is_running: return
    var my_delta = delta * client.computer_speed
    client.time += my_delta
    if client.tick_rate == 0: return
    if client.is_running: client.tick_time += my_delta
    var time_to_tick = 1.0 / client.tick_rate
    while client.tick_time >= time_to_tick:
        client.tick_time -= time_to_tick
        client.tick += 1

func adjust_client_tick_rate():
    if not client.is_running: return
    if client.server_tick_rate == 0: return    
    var time = client.time
    var last_time = client.last_received_time
    var tick_rate = client.server_tick_rate
    var time_tick_reported_at_server = client.last_received_time - client.latency
    var time_since_last_received = client.time - time_tick_reported_at_server
    var ticks = round(time_since_last_received * client.server_tick_rate)
    client.server_tick = int(client.last_received_tick + ticks)
    var latency_buffer = clamp(client.rtt * client.server_tick_rate * 2, 1, 100)
    client.target_tick = int(client.server_tick + latency_buffer)
    client.tick_rate = client.server_tick_rate + (client.target_tick - client.tick) * 3
    client.tick_rate = int(clamp(client.tick_rate, 1, 200))
    client.send_rate = client.tick_rate    
    client.send_rate = clamp(client.send_rate, 30, 45)
    
func display_variables():    
    $Time/Server.text = ""
    $Time/Client.text = ""
    for variable in server: 
        if variable.find("history") > -1: continue
        if variable.find("_window") > -1: continue
        if server[variable] is float:
            $Time/Server.text += variable + ": " + "%0.3f" % server[variable] + "\n"
        else:
            $Time/Server.text += variable + ": " + String(server[variable]) + "\n"
    
    for variable in client:
        if variable.find("history") > -1: continue
        if variable.find("_window") > -1: continue
        if client[variable] is float:
            $Time/Client.text += variable + ": " + "%0.3f" % client[variable] + "\n"
        else:
            $Time/Client.text += variable + ": " + String(client[variable]) + "\n"

func on_client_connect():
    client.is_connected = true

func on_client_disconnect():
    client.is_connected = false

func send_data(client_or_server):
    var time_since_last_sent = client_or_server.time - client_or_server.last_sent_time
    if time_since_last_sent >= 1.0 / client_or_server.send_rate:
        client_or_server.last_sent_time = client_or_server.time
        var time_since_last_received = client_or_server.time - client_or_server.last_received_time
        var data = [client_or_server.tick, client_or_server.tick_rate,
                client_or_server.last_received_tick, time_since_last_received, client_or_server.time]
        var message = "%s,%s,%s,%s,%s" % data
        
        if client_or_server == server:
            $Server/History.sent.append(data)
            for client in $Server/TCP.clients:
                $Latency.send(client, message)
        else:
            $Client/History.sent.append(data)
            $Latency.send($Client/TCP.client, message)

func on_client_receive(message):
    var items = message.split(",")
    var incoming_tick = int(items[0])
    if client.last_received_tick >= incoming_tick: return
    
    client.last_received_tick = incoming_tick
    if client.server_tick_rate == 0: client.tick = client.last_received_tick
    
    client.last_received_time = client.time
    client.server_tick_rate = int(items[1])
    var last_sent_tick = int(items[2])
    var server_wait_time = float(items[3])
    
    var data = $Client/History.get_sent_from_tick(last_sent_tick)
    if data != null:
        client.rtt = client.time - data[4] - server_wait_time        
        
        client.rtt_window.append(client.rtt)
        while client.rtt_window.size() > client.rtt_window_size:
            client.rtt_window.pop_front()
        for rtt in client.rtt_window:
            if client.rtt < rtt:
                client.rtt = rtt
        client.latency = client.rtt / 2
        
    $Client/History.clear_sent_before_tick(last_sent_tick)

func on_server_receive(_client, message):
    var items = message.split(",")
    server.last_received_tick = int(items[0])
    server.last_received_time = server.time
    var last_sent_tick = int(items[2])
    var client_wait_time = float(items[3])
    $Server/History.received.append([server.last_received_tick])
    $Server/History.received.append([server.last_received_tick-1])
    $Server/History.received.append([server.last_received_tick-2])
    
    var data = $Server/History.get_sent_from_tick(last_sent_tick)
    if data != null:
        server.rtt = server.time - data[4] - client_wait_time
        
        server.rtt_window.append(server.rtt)
        while server.rtt_window.size() > server.rtt_window_size:
            server.rtt_window.pop_front()
        for rtt in server.rtt_window:
            if server.rtt < rtt:
                server.rtt = rtt
        server.latency = server.rtt / 2
    $Server/History.clear_sent_before_tick(last_sent_tick)
