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
    console_write_ln("Starting Server...")
    var _1 = $WebSocketServer.connect("on_open", self, "create_web_socket_server_input")
    var _2 = $WebSocketServer.connect("on_close", self, "remove_client")
    if get_parent() == get_tree().get_root():
        var _3 = $WebSocketServer.listen()
    else:
        var _3 = $WebSocketServer.listen_insecure()
    var _4 = $WebSocketServer.connect("on_receive", $Kbps, "add_client_data")
    console_write_ln("Awaiting new connection...")

func _process(delta):
    update_timer += delta
    if update_timer < 1.0 / update_rate: return
    update_timer -= 1.0 / update_rate
    if has_node("WebSocketServer"):
        for client in $WebSocketServer.clients:
            var input = clients[client].input
            var ship_id = clients[client].ship.id
            var client_tick = input.latest_received_tick
            var offset = input.time - input.latest_received_time
            var world_dictionary = $World.to_dictionary(client_tick, offset, ship_id)
            var json = to_json(world_dictionary)
            $WebSocketServer.send(client, json)

func create_web_socket_server_input(client):
    var input = NetworkServerPlayerInput.new("WebSocketPlayer", client)
    $Inputs.add_child(input)
    var ship = $World.create_player(input)
    var host = client.get_connected_host()
    var port = client.get_connected_port()
    clients[client] = {"input": input, "ship": ship, "host": host, "port": port }
    # $DebugOverlay.add_stat("Misses", input, "misses", false) Causes problems!!!!
    var _1 = $WebSocketServer.connect("on_receive", self, "process_message")
    console_write_ln("A Client has connected! %s:%s" % [host, port])

func remove_client(client):
    var c = clients[client]
    console_write_ln("A Client has disconnected! %s:%s" % [c.host, c.port])
    var input = clients[client].input
    $World.delete_player(input)
    input.queue_free();
    clients.erase(client)

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)

func process_message(client, message):
    var dictionary = parse_json(message)
    if dictionary.type == "input":
        clients[client].input.deserialize(dictionary.list)
    if dictionary.type == "chat":
        dictionary.message = "%s: %s" % [clients[client].input.username, dictionary.message]
        $WebSocketServer.broadcast(to_json(dictionary))
