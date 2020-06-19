extends Node

signal on_open()
signal on_close()
signal on_receive(message)
signal on_send(message)

var client = StreamPeerTCP.new()
var connected = false

func _process(delta):
    check_for_connection()
    check_for_disconnection()
    check_for_received_data()

func open(host = "localhost", port = 11001):
    client.connect_to_host(host, port)

func check_for_connection():
    if not connected:
        if client and client.is_connected_to_host():
            connected = true
            emit_signal("on_open")

func check_for_disconnection():
    if connected:
        if not client or not client.is_connected_to_host():
            connected = false
            emit_signal("on_close")

func check_for_received_data():
    if client and client.is_connected_to_host():
        var bytes = client.get_available_bytes()
        if bytes > 0:
            var data = client.get_data(bytes)
            var message = data[1].get_string_from_ascii()
            emit_signal("on_receive", message)

func send(message):
    if client and client.is_connected_to_host():
        client.put_data(message.to_ascii())
        emit_signal("on_send", message)
