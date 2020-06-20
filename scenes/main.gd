extends Node

func _enter_tree():
    #warning-ignore-all:return_value_discarded
    $Inputs.connect("node_added", self, "input_connected")
    $Inputs.connect("node_removed", self, "input_disconnected")
    
    if has_node("TCPServer"):
        console_write_ln("Starting Server...")
        $TCPServer.connect("on_open", self, "create_tcp_server_input")
        $TCPServer.connect("on_close", self, "remove_server_input")
        $TCPServer.listen()
        console_write_ln("Awaiting new connection...")
    
    if has_node("WebSocketServer"):
        console_write_ln("Starting Server...")
        $WebSocketServer.connect("on_open", self, "create_web_socket_server_input")
        $WebSocketServer.connect("on_close", self, "remove_server_input")
        $WebSocketServer.listen()
        console_write_ln("Awaiting new connection...")
    
    if has_node("TCPClient"):
        console_write_ln("Connecting to Server...")
        $TCPClient.connect("on_open", self, "show_connected_to_server")
        $TCPClient.connect("on_close", self, "show_disconnected_to_server")
        $TCPClient.open()
    
    if has_node("WebSocketClient"):
        console_write_ln("Connecting to Server...")
        $WebSocketClient.connect("on_open", self, "show_connected_to_server")
        $WebSocketClient.connect("on_close", self, "show_disconnected_to_server")
        $WebSocketClient.open("ws://192.168.254.100:11001")
    
func input_connected(input):
    $World.create_player(input)

func input_disconnected(input):
    $World.delete_player(input)

func create_tcp_server_input(client):
    var input = $Inputs.add(TCPServerInput.new(), {"client": client})
    $TCPServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func create_web_socket_server_input(client):
    var input = $Inputs.add(TCPServerInput.new(), {"client": client})
    input.input_name = input.input_name.replace("TCP", "WebSocket")
    $WebSocketServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func remove_server_input(client):
    console_write_ln("A Client has disconnected!")
    for input in $Inputs.get_children():
        if input.client == client:
            input.queue_free();
            return

func show_connected_to_server():
    console_write_ln("Connected to Server!")

func show_disconnected_to_server():
    console_write_ln("Disconnected from Server!")

export var input_rate = 10
var input_timer = 0.0

export var update_rate = 10
var update_timer = 0.0

func _ready():
    if has_node("TCPClient"):
        $TCPClient.connect("on_receive", $World, "deserialize")
    if has_node("WebSocketClient"):
        $WebSocketClient.connect("on_receive", $World, "deserialize")

func _process(delta):
    if has_node("TCPClient") || has_node("WebSocketClient"):
        input_timer += delta
        if input_timer < 1.0 / input_rate: return
        input_timer -= 1.0 / input_rate
        #$TCPClient.send($Inputs/Input.serialize())
        if has_node("TCPClient"):
            $LatencySimulator.send($TCPClient.client, $Inputs/Input.serialize())
        if has_node("WebSocketClient"):
            $WebSocketClient.send($Inputs/Input.serialize())
    
    if has_node("TCPServer") || has_node("WebSocketServer"):
        update_timer += delta
        if update_timer < 1.0 / update_rate: return
        update_timer -= 1.0 / update_rate
        #$TCPServer.broadcast($World.serialize())
        if has_node("TCPServer"):
            for client in $TCPServer.clients:
                $LatencySimulator.send(client, $World.serialize())
        if has_node("WebSocketServer"):
            for client in $WebSocketServer.clients:
                $WebSocketServer.send(client, $World.serialize())

func console_write_ln(message):
    print(message)
    if $UI/Console: $UI/Console.write_line(message)
    if $UI/Banner/Label: $UI/Banner/Label.text = message
