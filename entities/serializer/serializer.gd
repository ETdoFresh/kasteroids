class_name Serializer
extends Node

var tick
var last_received_client_tick
var offset

onready var world = get_parent()
onready var asteroids = world.get_node("Asteroids")
onready var bullets = world.get_node("Bullets")
onready var ships = world.get_node("Ships")

func serialize():
    var serialized = "%d,%d,%d," % [tick, last_received_client_tick, offset]
    for group in [ships, asteroids, bullets]:
        serialized += String(group.get_child_count()) + ","
        for node in group.get_children():
            if node.has_node("Data"):
                var data = node.get_node("Data")
                serialized += data.serialize()
    return serialized
