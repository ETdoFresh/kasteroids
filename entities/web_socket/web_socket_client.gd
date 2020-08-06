extends Node

const CONNECTED = WebSocketClient.CONNECTION_CONNECTED

signal on_open()
signal on_close()
signal on_receive(message)
signal on_send(message)

var client = WebSocketClient.new()
var client_peer
var connected = false

func _process(_delta):
    client.poll()

func open(url = "ws://localhost:11001"):
    if url.to_lower().begins_with("wss") &&  OS.get_name() != "HTML5":
        client.verify_ssl = false
        client.trusted_ssl_certificate = X509Certificate.new()
        client.trusted_ssl_certificate.load("res://keys/cert.crt")
    client.connect("connection_established", self, "check_for_connection")
    client.connect("connection_closed", self, "check_for_disconnection")
    client.connect("data_received", self, "check_for_received_data")
    client.connect_to_url(url)

func send(message):
    if client and client.get_connection_status() == CONNECTED:
        client_peer.put_packet(message.to_ascii())
        emit_signal("on_send", message)

func check_for_connection(_protocol):
    emit_signal("on_open")
    client_peer = client.get_peer(1)

func check_for_disconnection(_was_clean_close):
    emit_signal("on_close")

func check_for_received_data():
    for _i in range(client_peer.get_available_packet_count()):
        var packet = client_peer.get_packet()
        var message = packet.get_string_from_ascii()
        emit_signal("on_receive", message)
