extends TCPNetworkConnection

func _ready():
    self.open("localhost", 11001)
