extends Node

onready var latest_received_world = $LatestReceivedWorld
onready var interpolated_world = $InterpolatedWorld
onready var extrapolated_world = $ExtrapolatedWorld

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
    for existing_input in $Inputs.get_children():
        latest_received_world.create_player(existing_input)
        existing_input.connect("tree_exited", latest_received_world,"delete_player", [existing_input])
    
    if has_node("TCPClient"):
        var _1 = $TCPClient.connect("on_receive", latest_received_world, "deserialize")
        var _2 = $TCPClient.connect("on_receive", interpolated_world, "deserialize")
        var _3 = $TCPClient.connect("on_receive", extrapolated_world, "deserialize")
    if has_node("WebSocketClient"):
        var _1 = $WebSocketClient.connect("on_receive", latest_received_world, "deserialize")
        var _2 = $WebSocketClient.connect("on_receive", interpolated_world, "deserialize")
        var _3 = $WebSocketClient.connect("on_receive", extrapolated_world, "deserialize")
    
    $DebugOverlay.add_stat("Tick", $LatestReceivedWorld/Tick, "tick", false)
    $DebugOverlay.add_stat("RTT", $LatestReceivedWorld/ServerTickSync, "rtt", false)
    $DebugOverlay.add_stat("Lastest Received Tick", $LatestReceivedWorld/ServerTickSync, "last_received_server_tick", false)
    $DebugOverlay.add_stat("Prediction", $LatestReceivedWorld/ServerTickSync, "prediction", false)
    $DebugOverlay.add_stat("Future Tick", $LatestReceivedWorld/ServerTickSync, "future_tick", false)
    $DebugOverlay.add_stat("SmoothTick", $LatestReceivedWorld/ServerTickSync, "smooth_tick", false)
    $DebugOverlay.add_stat("Receive Rate", $LatestReceivedWorld/ServerTickSync, "receive_rate", false)
    $DebugOverlay.add_stat("Interpolated Tick", $LatestReceivedWorld/ServerTickSync, "interpolated_tick", false)

func _process(_delta):
    if has_node("TCPClient") || has_node("WebSocketClient"):

        #$TCPClient.send($Inputs/Input.serialize())
        $Inputs/Input.tick = latest_received_world.get_node("ServerTickSync").smooth_tick
        if has_node("TCPClient"):
            $LatencySimulator.send($TCPClient.client, $Inputs/Input.serialize())
        if has_node("WebSocketClient"):
            $WebSocketClient.send($Inputs/Input.serialize())
        
        $LatestReceivedWorld/ServerTickSync.record_client_send($Inputs/Input.tick)
        $InterpolatedWorld/ServerTickSync.record_client_send($Inputs/Input.tick)
        $ExtrapolatedWorld/ServerTickSync.record_client_send($Inputs/Input.tick)

func show_connected_to_server():
    console_write_ln("Connected to Server!")

func show_disconnected_to_server():
    console_write_ln("Disconnected from Server!")

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
