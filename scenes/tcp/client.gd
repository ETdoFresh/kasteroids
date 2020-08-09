extends Node

export var send_rate_per_second = 15
var time_since_send = 0
var worlds = []

onready var latest_received_world = $LatestReceivedWorld

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
        $WebSocketClient.open("wss://etdofresh.synology.me:11001")

func _ready():
    if has_node("LatestReceivedWorld"): worlds.append(get_node("LatestReceivedWorld"))
    if has_node("InterpolatedWorld"): worlds.append(get_node("InterpolatedWorld"))
    if has_node("ExtrapolatedWorld"): worlds.append(get_node("ExtrapolatedWorld"))
    if has_node("PredictedWorld"): worlds.append(get_node("PredictedWorld"))
    
    for existing_input in $Inputs.get_children():
        latest_received_world.create_player(existing_input)
        existing_input.connect("tree_exited", latest_received_world,"delete_player", [existing_input])
    
    if has_node("TCPClient"):
        for world in worlds:
            var _1 = $TCPClient.connect("on_receive", world, "deserialize")
        var _5 = $TCPClient.connect("on_receive", $ReceivedKbps, "add_data")
    if has_node("WebSocketClient"):
        for world in worlds:
            var _1 = $WebSocketClient.connect("on_receive", world, "deserialize")
        var _5 = $WebSocketClient.connect("on_receive", $ReceivedKbps, "add_data")
    
    $DebugOverlay.add_stat("Tick", $LatestReceivedWorld/Tick, "tick", false)
    $DebugOverlay.add_stat("RTT", $LatestReceivedWorld/ServerTickSync, "rtt", false)
    $DebugOverlay.add_stat("Lastest Received Server Tick", $LatestReceivedWorld/ServerTickSync, "last_received_server_tick", false)
    $DebugOverlay.add_stat("Lastest Received Client Tick", $LatestReceivedWorld/ServerTickSync, "last_received_client_tick", false)
    $DebugOverlay.add_stat("Prediction", $LatestReceivedWorld/ServerTickSync, "prediction", false)
    $DebugOverlay.add_stat("Future Tick", $LatestReceivedWorld/ServerTickSync, "future_tick", false)
    $DebugOverlay.add_stat("SmoothTick", $LatestReceivedWorld/ServerTickSync, "smooth_tick", false)
    $DebugOverlay.add_stat("Receive Rate", $LatestReceivedWorld/ServerTickSync, "receive_rate", false)
    $DebugOverlay.add_stat("Interpolated Tick", $LatestReceivedWorld/ServerTickSync, "interpolated_tick", false)
    $DebugOverlay.add_stat("Received Kbps", $ReceivedKbps, "value", false)
    $DebugOverlay.add_stat("Received Packets/Sec", $ReceivedKbps, "count", false)
    $DebugOverlay.add_stat("Sent Kbps/Sec", $SentKbps, "value", false)
    $DebugOverlay.add_stat("Sent Packets/Sec", $SentKbps, "count", false)

func _process(delta):
    if has_node("TCPClient") || has_node("WebSocketClient"):

        #$TCPClient.send($Inputs/Input.serialize())
        $Inputs/Input.tick = latest_received_world.get_node("ServerTickSync").smooth_tick
        
        time_since_send += delta
        if time_since_send < 1.0 / send_rate_per_second:
            $Inputs/Input.serialize()
            return
        else:
            time_since_send -= 1.0 / send_rate_per_second
        
        if has_node("TCPClient"):
            var message = $Inputs/Input.serialize()
            $LatencySimulator.send($TCPClient.client, message)
            $SentKbps.add_data(message)
        if has_node("WebSocketClient"):
            var message = $Inputs/Input.serialize()
            $WebSocketClient.send(message)
            $SentKbps.add_data(message)
        
        for world in worlds:
            world.server_tick_sync.record_client_send($Inputs/Input.tick)
            world.server_tick_sync.client_send_rate = send_rate_per_second

func show_connected_to_server():
    console_write_ln("Connected to Server!")

func show_disconnected_to_server():
    console_write_ln("Disconnected from Server!")

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
