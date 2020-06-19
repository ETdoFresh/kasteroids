extends TCPNetworkConnection

onready var world = $World/Deserializer

func _ready():
    open("localhost", 11001)
    connect("on_receive", self, "on_receive")

func on_receive(_client, message):
    world.deserialize(message)
