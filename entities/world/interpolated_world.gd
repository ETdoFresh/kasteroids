extends Node2D

var input = Data.NULL_INPUT
var server_tick_sync

onready var place_holder_data = $PlaceHolderData

func simulate(_delta):
    if server_tick_sync:
        var tick = server_tick_sync.smooth_tick_rounded
        var rtt = server_tick_sync.rtt
        var receive_rate = server_tick_sync.receive_rate
        var interpolated_tick = $Interpolation.get_interpolated_tick(tick, rtt, receive_rate)
        $Interpolation.interpolate(interpolated_tick)

func deserialize(serialized):
    var dictionary = parse_json(serialized)
    $Interpolation.add_history(dictionary)
