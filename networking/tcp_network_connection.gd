extends Node

class_name TCPNetworkConnection

#warning-ignore:unused_signal
signal on_open(client)

#warning-ignore:unused_signal
signal on_close(client)

#warning-ignore:unused_signal
signal on_receive(client, message)

#warning-ignore:unused_signal
signal on_send(client, message)

export var simulate_latency = true
export var min_latency = 0.100
export var max_latency = 0.300
export var drop_rate = 0.10
export var dup_rate = 0.05
export var out_of_order = true

var server = TCP_Server.new()
var clientPeer = StreamPeerTCP.new()

var queue = []
var clients = []

func _init():
    randomize()

#warning-ignore:unused_argument
func _process(delta):
    if server:
        var incoming_connection = server.take_connection()
        if incoming_connection != null:
            clients.append(incoming_connection)
            
    for client in clients:
        if not client.is_connected_to_host():
            for i in range(clients.size()-1, -1, -1):
                if clients[i] == client:
                    clients.remove(i)
    
    if clientPeer and clientPeer.is_connected_to_host():
        var bytes = clientPeer.get_available_bytes()
        if bytes > 0:
            var data = clientPeer.get_data(bytes)
            var message = data[1].get_string_from_ascii()
            emit_signal("on_receive", clientPeer, message)
    
    while not queue.empty():
        var t = OS.get_ticks_msec() / 1000.0
        if t < queue[0][0]: break
        var data = queue.pop_front()[1].to_ascii()
        for client in clients:
            client.put_data(data)

func listen(bind_address = "*", port = 11001):
    server.listen(port, bind_address)

func open(host = "localhost", port = 11001):
    clientPeer.connect_to_host(host, port)

func send(client, message):
    if not simulate_latency:
        queue.push_back([0, message])
        emit_signal("on_send", client, message)
        return
        
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

