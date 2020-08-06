extends Node

func _ready():
    $Client/LatestReceivedWorld/Background.visible = false
    $Client/KeyboardShortcuts.queue_free()
    $Client/UI.visible = false
