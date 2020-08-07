extends Node

var future_time = 0

func _ready():
    $Client/LatestReceivedWorld/Background.visible = false
    $Client/KeyboardShortcuts.queue_free()
    $Client/UI.visible = false
    $Client/DebugOverlay.add_stat("Seconds in Future", self, "future_time", false)

func _process(_delta):
    future_time = $Client/LatestReceivedWorld/ServerTickSync.smooth_tick
    future_time -= $Server/World/Tick.tick
    future_time *= 1.0 / Engine.iterations_per_second
