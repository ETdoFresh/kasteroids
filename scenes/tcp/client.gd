extends Node

export var send_rate_per_second = 15
var time_since_send = 0
var worlds = []

var input_message

onready var latest_received_world = $LatestReceivedWorld
onready var server_tick_sync = $ServerTickSync
onready var received_kbps = $ReceivedKbps
onready var sent_kbps = $SentKbps

func _enter_tree():
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
        $WebSocketClient.open("wss://etdofresh.synology.me:11001")

func _ready():
    $Inputs/Input.input_name = Data.get_username()
    
    if has_node("LatestReceivedWorld"): worlds.append(get_node("LatestReceivedWorld"))
    if has_node("InterpolatedWorld"): worlds.append(get_node("InterpolatedWorld"))
    if has_node("ExtrapolatedWorld"): worlds.append(get_node("ExtrapolatedWorld"))
    if has_node("PredictedWorld"): worlds.append(get_node("PredictedWorld"))
    
    server_tick_sync.connect("tick", self, "update_input")
    for world in worlds:
        var _1 = server_tick_sync.connect("tick", world, "simulate", [Settings.tick_rate])
        if "server_tick_sync" in world:
            world.server_tick_sync = server_tick_sync
    
    #for existing_input in $Inputs.get_children():
        #latest_received_world.create_player(existing_input)
        #existing_input.connect("tree_exited", latest_received_world,"delete_player", [existing_input])
    
    if has_node("TCPClient"):
        for world in worlds:
            var _1 = $TCPClient.connect("on_receive", world, "deserialize")
        var _1 = $TCPClient.connect("on_receive", server_tick_sync, "record_client_receive_message")
        var _2 = $TCPClient.connect("on_receive", received_kbps, "add_data")
        
    if has_node("WebSocketClient"):
        for world in worlds:
            var _1 = $WebSocketClient.connect("on_receive", world, "deserialize")
        var _1 = $WebSocketClient.connect("on_receive", server_tick_sync, "record_client_receive_message")
        var _2 = $WebSocketClient.connect("on_receive", received_kbps, "add_data")
    
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

func update_input():
    $Inputs/Input.tick = server_tick_sync.smooth_tick_rounded
    input_message = $Inputs/Input.serialize()

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
