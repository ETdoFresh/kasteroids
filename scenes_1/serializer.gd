extends Node

onready var world = get_parent()
onready var state = world.state

func serialize():
    var serialized = ""
    var types = [Ship, Asteroid, Bullet]
    for type in types:
        var nodes = get_items_of_type(state, type)
        serialized += String(nodes.size()) + ","
        for node in nodes:
            serialized += String(node.position.x) + ","
            serialized += String(node.position.y) + ","
            serialized += String(node.rotation) + ","
            serialized += String(node.scale.x) + ","
            serialized += String(node.scale.y) + ","
    return serialized

func get_items_of_type(list, type):
    var items = []
    for item in list:
        if item is type:
            items.append(item)
    return items
