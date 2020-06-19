extends Node

func _enter_tree():
    $Inputs.connect("node_added", self, "input_connected")
    $Inputs.connect("node_removed", self, "input_disconnected")
    
    if has_node("TCPServer"):
        $TCPServer.connect("on_open", self, "create_tcp_server_input")
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

export var net_fps = 10
var net_fps_timer = 0.0
func _process(delta):
    if has_node("TCPClient"):
        net_fps_timer += delta
        if net_fps_timer < 1.0 / net_fps: return
        net_fps_timer -= 1.0 / net_fps
        var serialized =$Inputs/Input.serialize() 
        $TCPClient.send(serialized)
