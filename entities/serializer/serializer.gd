class_name Serializer
extends Node

var ships = []
var asteroids = []
var bullets = []

func track_node(node):
    if node is Ship: ships.append(node)
    elif node is Asteroid: asteroids.append(node)
    elif node is Bullet: bullets.append(node)

func untrack_node(node):
    for list in [ships, asteroids, bullets]:
        for i in range(list.size() - 1, -1, -1):
            if list[i] == node:
                list.remove(i)

func serialize():
    var serialized = ""
    for list in [ships, asteroids, bullets]:
        serialized += String(list.size()) + ","
        for node in list:
            if node.has_node("Data"):
                var data = node.get_node("Data")
                serialized += String(data.position.x) + ","
                serialized += String(data.position.y) + ","
                serialized += String(data.rotation) + ","
                serialized += String(data.scale.x) + ","
                serialized += String(data.scale.y) + ","
    return serialized
