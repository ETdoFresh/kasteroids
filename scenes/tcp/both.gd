extends Node

func _ready():
    $Client/World/Background.visible = false
    $Client/KeyboardShortcuts.queue_free()
    $Client/UI.visible = false
