extends TCPNetworkConnection

export var net_fps = 10

var net_fps_timer = 0.0

onready var world = $World/Serializer

func _ready():
    self.listen("*", 11001)

func _physics_process(delta):
    net_fps_timer += delta
    if net_fps_timer < 1.0 / net_fps: return
    net_fps_timer -= 1.0 / net_fps
    send(null, world.serialize())
