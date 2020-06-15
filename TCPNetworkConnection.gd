extends Node

class_name TCPNetworkConnection

signal on_open(client)
signal on_close(client)
signal on_receive(client, message)
signal on_send(client, message)

export var min_latency = 0.100
export var max_latency = 0.300
export var drop_rate = 0.10
export var dup_rate = 0.05
export var out_of_order = true

var server = TCP_Server.new()
var client = StreamPeerTCP.new()

var queue = []
var clients = []

func _init():
    randomize()

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
    
    if client and client.is_connected_to_host():
        var bytes = client.get_available_bytes()
        if bytes > 0:
            var data = client.get_data(bytes)
            var message = data[1].get_string_from_ascii()
            #print(bytes)
            #print(str(message))
            emit_signal("on_receive", client, message)
    
#    while not queue.empty():
#        var t = OS.get_ticks_msec() / 1000.0
#        if t < queue[0][0]: break
#        for client in clients:
#            client.put_utf8_string(queue.pop_front()[1])

func listen(bind_address = "*", port = 11001):
    server.listen(port, bind_address)

func open(host = "localhost", port = 11001):
    client.connect_to_host(host, port)

func send(client, message):
    for client in clients:
        client.put_data(message.to_ascii())
        
#    if randf() < drop_rate: return
#
#    var t = OS.get_ticks_msec() / 1000.0
#
#    var duration = 0
#    if max_latency > 0:
#        duration = t + min_latency + randf() * (max_latency - min_latency)
#
#    queue.push_back([duration, message])
#
#    while randf() < dup_rate:
#        var duplicate_duration = t + min_latency + randf() * (max_latency - min_latency)
#        queue.push_back([duplicate_duration, message])
#
#    if out_of_order:
#        queue.sort_custom(self, "sort_duration")
#
#    emit_signal("on_send", client, message)

func sort_duration(a, b):
    return a[0] < b[0]

