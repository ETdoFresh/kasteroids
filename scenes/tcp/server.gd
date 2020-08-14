extends Node

export var update_rate = 10

var update_timer = 0.0
var clients = {}

func _ready():
    for existing_input in $Inputs.get_children():
        $World.create_player(existing_input)
        existing_input.connect("tree_exited", $World,"delete_player", [existing_input])
    
    if has_node("DebugOverlay"):
        $DebugOverlay.add_stat("Tick", $World/Tick, "tick", false)
        if has_node("Kbps"):
            $DebugOverlay.add_stat("Kbps", $Kbps, "value", false)

func _enter_tree():    
    if has_node("TCPServer"):
        console_write_ln("Starting Server...")
        var _1 = $TCPServer.connect("on_open", self, "create_tcp_server_input")
        var _2 = $TCPServer.connect("on_close", self, "remove_client")
        var _3 = $TCPServer.listen()
        var _4 = $TCPServer.connect("on_receive", $Kbps, "add_client_data")
        console_write_ln("Awaiting new connection...")
    
    if has_node("WebSocketServer"):
        console_write_ln("Starting Server...")
        var _1 = $WebSocketServer.connect("on_open", self, "create_web_socket_server_input")
        var _2 = $WebSocketServer.connect("on_close", self, "remove_client")
        var _3 = $WebSocketServer.listen()
        #var _3 = $WebSocketServer.listen_insecure()
        var _4 = $WebSocketServer.connect("on_receive", $Kbps, "add_client_data")
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
                var input = clients[client].input
                var ship_id = clients[client].ship.id
                var client_tick = input.latest_received_tick
                var offset = input.time - input.latest_received_time
                var world_dictionary = $World.to_dictionary(client_tick, offset, ship_id)
                var json = to_json(world_dictionary)
                $LatencySimulator.send(client, json)
        if has_node("WebSocketServer"):
            for client in $WebSocketServer.clients:
                var input = clients[client].input
                var ship_id = clients[client].ship.id
                var client_tick = input.latest_received_tick
                var offset = input.time - input.latest_received_time
                var world_dictionary = $World.to_dictionary(client_tick, offset, ship_id)
                var json = to_json(world_dictionary)
                $WebSocketServer.send(client, json)

func create_tcp_server_input(client):
    var input = NetworkServerPlayerInput.new("TCPPlayer", client)
    $Inputs.add_child(input)
    var ship = $World.create_player(input)
    clients[client] = {"input": input, "ship": ship}
    $DebugOverlay.add_stat("Misses", input, "misses", false)
    $DebugOverlay.add_stat("Last Received Tick", input, "latest_received_tick", false)
    var _1 = $TCPServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func create_web_socket_server_input(client):
    var input = NetworkServerPlayerInput.new("WebSocketPlayer", client)
    $Inputs.add_child(input)
    var ship = $World.create_player(input)
    clients[client] = {"input": input, "ship": ship}
    $DebugOverlay.add_stat("Misses", input, "misses", false)
    var _1 = $WebSocketServer.connect("on_receive", input, "deserialize")
    console_write_ln("A Client has connected!")

func remove_client(client):
    console_write_ln("A Client has disconnected!")
    var input = clients[client].input
    $World.delete_player(input)
    input.queue_free();
    clients.erase(client)

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
