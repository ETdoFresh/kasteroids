extends Node

export var input_rate = 10

var input_timer = 0.0

#onready var interpolated_world = $InterpolatedWorld
#onready var predicted_world = $PredictedWorld

func _enter_tree():
    #warning-ignore-all:return_value_discarded
    $Inputs.connect("node_added", self, "input_connected")
    $Inputs.connect("node_removed", self, "input_disconnected")
    
    if has_node("TCPClient"):
        console_write_ln("Connecting to Server...")
        $TCPClient.connect("on_open", self, "show_connected_to_server")
        $TCPClient.connect("on_close", self, "show_disconnected_to_server")
        $TCPClient.open()
    
    if has_node("WebSocketClient"):
        console_write_ln("Connecting to Server...")
        $WebSocketClient.connect("on_open", self, "show_connected_to_server")
        $WebSocketClient.connect("on_close", self, "show_disconnected_to_server")
        $WebSocketClient.open("wss://etdofresh.synology.me:11001")

func _ready():
    if has_node("TCPClient"):
        $TCPClient.connect("on_receive", $World, "deserialize")
        #$TCPClient.connect("on_receive", interpolated_world, "deserialize")
        #$TCPClient.connect("on_receive", predicted_world, "deserialize")
    if has_node("WebSocketClient"):
        $WebSocketClient.connect("on_receive", $World, "deserialize")
        #$WebSocketClient.connect("on_receive", interpolated_world, "deserialize")
        #$WebSocketClient.connect("on_receive", predicted_world, "deserialize")

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

func input_connected(input):
    $World.create_player(input)

func input_disconnected(input):
    $World.delete_player(input)

func show_connected_to_server():
    console_write_ln("Connected to Server!")

func show_disconnected_to_server():
    console_write_ln("Disconnected from Server!")

func console_write_ln(message):
    print(message)
    if has_node("UI/Console"): $UI/Console.write_line(message)
    if has_node("UI/Banner"): $UI/Banner.set_text(message)
