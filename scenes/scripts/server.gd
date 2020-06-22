extends Node

export var update_rate = 10

var update_timer = 0.0

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

func _process(delta):    
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

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
