extends Node

export var send_rate_per_second = 15
var time_since_send = 0
var worlds = []

var input_message

onready var latest_received_world = $LatestReceivedWorld
onready var server_tick_sync = $ServerTickSync
onready var received_kbps = $ReceivedKbps
onready var sent_kbps = $SentKbps
onready var console = $UI/Console

func _ready():
    if has_node("TCPClient"):
        console_write_ln("Connecting to Server...")
        var _1 = $TCPClient.connect("on_open", self, "show_connected_to_server")
        var _2 = $TCPClient.connect("on_close", self, "show_disconnected_to_server")
        $TCPClient.open()
    
    if has_node("WebSocketClient"):
        console_write_ln("Connecting to Server...")
        var _1 = $WebSocketClient.connect("on_open", self, "show_connected_to_server")
        var _2 = $WebSocketClient.connect("on_close", self, "show_disconnected_to_server")
        #$WebSocketClient.open()
        if get_parent() == get_tree().get_root():
            $WebSocketClient.open(Settings.client_url)
        else:
            $WebSocketClient.open()
    
    $Inputs/Input.username = Data.get_username()
    
    if has_node("LatestReceivedWorld"): worlds.append(get_node("LatestReceivedWorld"))
    if has_node("InterpolatedWorld"): worlds.append(get_node("InterpolatedWorld"))
    if has_node("ExtrapolatedWorld"): worlds.append(get_node("ExtrapolatedWorld"))
    if has_node("PredictedWorld"): worlds.append(get_node("PredictedWorld"))
    if has_node("InterpolatedPredictedWorld"): worlds.append(get_node("InterpolatedPredictedWorld"))
    
    server_tick_sync.connect("tick", self, "update_input")
    for world in worlds:
        var _1 = server_tick_sync.connect("tick", world, "simulate", [Settings.tick_rate])
        if "server_tick_sync" in world: world.server_tick_sync = server_tick_sync
        if "input" in world: world.input = $Inputs/Input
    
    #for existing_input in $Inputs.get_children():
        #latest_received_world.create_player(existing_input)
        #existing_input.connect("tree_exited", latest_received_world,"delete_player", [existing_input])
    
    if has_node("TCPClient"):
        var _1 = $TCPClient.connect("on_receive", self, "process_message")
        
    if has_node("WebSocketClient"):
        var _1 = $WebSocketClient.connect("on_receive", self, "process_message")
    
    $DebugOverlay.add_stat("RTT", server_tick_sync, "rtt", false)
    $DebugOverlay.add_stat("Lastest Received Server Tick", server_tick_sync, "last_received_server_tick", false)
    $DebugOverlay.add_stat("Lastest Received Client Tick", server_tick_sync, "last_received_client_tick", false)
    $DebugOverlay.add_stat("Prediction", server_tick_sync, "prediction", false)
    $DebugOverlay.add_stat("Future Tick", server_tick_sync, "future_tick", false)
    $DebugOverlay.add_stat("SmoothTick", server_tick_sync, "smooth_tick", false)
    $DebugOverlay.add_stat("Receive Rate", server_tick_sync, "receive_rate", false)
    $DebugOverlay.add_stat("Interpolated Tick", server_tick_sync, "interpolated_tick", false)
    $DebugOverlay.add_stat("Received Kbps", received_kbps, "value", false)
    $DebugOverlay.add_stat("Received Packets/Sec", received_kbps, "count", false)
    $DebugOverlay.add_stat("Sent Kbps/Sec", sent_kbps, "value", false)
    $DebugOverlay.add_stat("Sent Packets/Sec", sent_kbps, "count", false)
    $DebugOverlay.add_stat("Prediction Misses", $PredictedWorld, "misses", false)
    console.connect("submitted_line", self, "send_chat")

func update_input():
    $Inputs/Input.tick = server_tick_sync.smooth_tick_rounded
    input_message = to_json($Inputs/Input.to_dictionary())

func send_chat(chat_message):
    var message = to_json({"type": "chat", "message": chat_message})
    if has_node("TCPClient"):
        $LatencySimulator.send($TCPClient.client, message)
        sent_kbps.add_data(message)
    if has_node("WebSocketClient"):
        $WebSocketClient.send(message)
        sent_kbps.add_data(message)

func _process(delta):
    if has_node("TCPClient") || has_node("WebSocketClient"):
        time_since_send += delta
        if time_since_send < 1.0 / send_rate_per_second:
            return
        else:
            time_since_send -= 1.0 / send_rate_per_second
        
        if not input_message:
            return
        
        if has_node("TCPClient"):
            $LatencySimulator.send($TCPClient.client, input_message)
            sent_kbps.add_data(input_message)
        if has_node("WebSocketClient"):
            $WebSocketClient.send(input_message)
            sent_kbps.add_data(input_message)
        
        server_tick_sync.record_client_send()

func show_connected_to_server():
    console_write_ln("Connected to Server!")

func show_disconnected_to_server():
    console_write_ln("Disconnected from Server!")

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)

func process_message(message):
    var dictionary = Data.str2vars_json(message)
    received_kbps.add_data(message)
    
    if dictionary.type == "Update":
        server_tick_sync.record_client_recieve(dictionary.tick, dictionary.client.tick, dictionary.client.offset)
        for world in worlds:
            world.received_data = dictionary
    
    if dictionary.type == "chat":
        $UI/Console.write_line(dictionary.message)
