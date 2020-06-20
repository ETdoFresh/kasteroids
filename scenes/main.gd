extends Node

func _enter_tree():
    $Inputs.connect("node_added", self, "input_connected")
    $Inputs.connect("node_removed", self, "input_disconnected")
    
    if has_node("TCPServer"):
        $TCPServer.connect("on_open", self, "create_tcp_server_input")
        $TCPServer.connect("on_close", self, "remove_tcp_server_input")
        $TCPServer.listen()
    
    if has_node("TCPClient"):
        $TCPClient.open()
    
func input_connected(input):
    $World.create_player(input)

func input_disconnected(input):
    $World.delete_player(input)

func create_tcp_server_input(client):
    var input = $Inputs.add(TCPServerInput.new(), {"client": client})
    $TCPServer.connect("on_receive", input, "deserialize")

func remove_tcp_server_input(client):
    for input in $Inputs.get_children():
        if input.client == client:
            input.queue_free();
            return

export var input_rate = 10
var input_timer = 0.0

export var update_rate = 10
var update_timer = 0.0

func _ready():
    if has_node("TCPClient"):
        $TCPClient.connect("on_receive", $World, "deserialize")

func _process(delta):
    if has_node("TCPClient"):
        input_timer += delta
        if input_timer < 1.0 / input_rate: return
        input_timer -= 1.0 / input_rate
        $TCPClient.send($Inputs/Input.serialize())
    
    if has_node("TCPServer"):
        update_timer += delta
        if update_timer < 1.0 / update_rate: return
        update_timer -= 1.0 / update_rate
        var serialized = $World.serialize()
        $TCPServer.broadcast($World.serialize())
        
