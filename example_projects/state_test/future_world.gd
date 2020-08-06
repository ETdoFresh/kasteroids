extends Node2D

var tick = 0
var world_history

func _process(_delta):
    if world_history == null:
        return
    
    tick = world_history.latest_tick
    if tick != null:
        for child_name in world_history.latest.keys():
            var child = find_node(child_name)
            child.position = world_history.latest[child_name].position
            child.rotation = world_history.latest[child_name].rotation
