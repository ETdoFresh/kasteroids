extends Node

export var update_rate = 10

var update_timer = 0.0

func _ready():
    for existing_input in $Inputs.get_children():
        $World.create_player(existing_input)
        existing_input.connect("tree_exited", $World,"delete_player", [existing_input])

func _enter_tree():    
    if has_node("TCPServer"):
        console_write_ln("Starting Server...")
        var _1 = $TCPServer.connect("on_open", self, "create_tcp_server_input")
        var _2 = $TCPServer.connect("on_close", self, "remove_server_input")
        var _3 = $TCPServer.listen()
        console_write_ln("Awaiting new connection...")
    
    if has_node("WebSocketServer"):
        console_write_ln("Starting Server...")
        var _1 = $WebSocketServer.connect("on_open", self, "create_web_socket_server_input")
        var _2 = $WebSocketServer.connect("on_close", self, "remove_server_input")
        var _3 = $WebSocketServer.listen()
        console_write_ln("Awaiting new connection...")

func _process(delta):
    for input in $Inputs.get_children():
        if input is NetworkServerPlayerInput:
            if not input.set_state_at_tick($World/Tick.tick):
                input.misses += 1
    
    if has_node("TCPServer") || has_node("WebSocketServer"):
        update_timer += delta
        if update_timer < 1.0 / update_rate: return
        update_timer -= 1.0 / update_rate
        #$TCPServer.broadcast($World.serialize())
        if has_node("TCPServer"):
            for client in $TCPServer.clients:
                var input = get_input_by_client(client)
                var client_tick = input.latest_received_tick
                var offset = input.time - input.latest_received_time
                $LatencySimulator.send(client, $World.serialize(client_tick, offset))
        if has_node("WebSocketServer"):
            for client in $WebSocketServer.clients:
                var input = get_input_by_client(client)
                var client_tick = input.latest_received_tick
                var offset = input.time - input.latest_received_time
                $WebSocketServer.send(client, $World.serialize(client_tick, offset))

func create_tcp_server_input(client):
    var input = NetworkServerPlayerInput.new("TCPPlayer", client)
    $Inputs.add_child(input)
    $World.create_player(input)
    var _1 = $TCPServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func create_web_socket_server_input(client):
    var input = NetworkServerPlayerInput.new("WebSocketPlayer", client)
    $Inputs.add_child(input)
    $World.create_player(input)
    var _1 = $WebSocketServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func remove_server_input(client):
    console_write_ln("A Client has disconnected!")
    var input = get_input_by_client(client)
    $World.delete_player(input)
    input.queue_free();

func get_input_by_client(client):
    for input in $Inputs.get_children():
        if input.client == client:
            return input
    return null

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
