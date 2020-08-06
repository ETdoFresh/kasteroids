class_name Serializer
extends Node

onready var world = get_parent()
onready var tick = world.get_node("Tick")
onready var asteroids = world.get_node("Asteroids")
onready var bullets = world.get_node("Bullets")
onready var ships = world.get_node("Ships")

func serialize():
    var serialized = "%d," % tick.tick
    for group in [ships, asteroids, bullets]:
        serialized += String(group.get_child_count()) + ","
        for node in group.get_children():
            if node.has_node("Data"):
                var data = node.get_node("Data")
                serialized += String(data.position.x) + ","
                serialized += String(data.position.y) + ","
                serialized += String(data.rotation) + ","
                serialized += String(data.scale.x) + ","
                serialized += String(data.scale.y) + ","
    return serialized
