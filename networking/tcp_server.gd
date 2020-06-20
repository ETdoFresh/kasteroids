extends Node

signal on_open(client)
signal on_close(client)
signal on_receive(client, message)
signal on_send(client, message)

var server = TCP_Server.new()
var clients = []

func _process(delta):    
    check_for_connection()
    check_for_disconnection()
    check_for_received_data()

func check_for_connection():
    if server:
        var incoming_connection = server.take_connection()
        if incoming_connection != null:
            clients.append(incoming_connection)
            emit_signal("on_open", incoming_connection)

func check_for_disconnection():
    for i in range(clients.size() - 1, -1, -1):
        var client = clients[i]
        if not client:
            clients.remove(i)
        elif not client.is_connected_to_host():
            clients.remove(i)
            emit_signal("on_close", client)

func check_for_received_data():
    for client in clients:
        if client and client.is_connected_to_host():
            var bytes = client.get_available_bytes()
            if bytes > 0:
                var data = client.get_data(bytes)
                var message = data[1].get_string_from_ascii()
                emit_signal("on_receive", client, message)

func listen(bind_address = "*", port = 11001):
    server.listen(port, bind_address)

func send(client, message):
    client.put_data(message.to_ascii())
    emit_signal("on_send", client, message)

func broadcast(message):
    for client in clients:
        send(client, message)
