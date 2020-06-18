extends Node

const resources = \
{
    ShipClient: preload("res://entities/ship/ship_client.tscn"),
    AsteroidClient: preload("res://entities/asteroid/asteroid_client.tscn"),
    BulletClient: preload("res://entities/bullet/bullet_client.tscn")
}

onready var world = get_parent()
onready var state = world.state

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = [ShipClient, AsteroidClient, BulletClient]
    var x = 0
        
    for type in types:
        var count = int(items[x]); x += 1
        var nodes = get_items_of_type(state, type)
        while nodes.size() > count:
            remove_item_by_type(state, type)
        
        while nodes.size() < count:
            var node = add_item_by_type(nodes, type)
        
        for i in range(count):
            var node = nodes[i]
            node.position.x = float(items[x]); x += 1
            node.position.y = float(items[x]); x += 1
            node.rotation = float(items[x]); x += 1
            node.scale.x = float(items[x]); x += 1
            node.scale.y = float(items[x]); x += 1

func get_items_of_type(list, type):
    var items = []
    for item in list:
        if item is type:
            items.append(item)
    return items

func remove_item(list, item):
    for i in range(list.size() - 1, -1, -1):
        if list[i] == item:
            list.remove(i)

func remove_item_by_type(list, type):
    for i in range(list.size() - 1, -1, -1):
        if list[i] is type:
            list.remove(i)

func add_item_by_type(list, type):
    var node = null
    if resources.has(type):
        node = resources[type].instance()
        
    if node != null:
        world.add_child(node)
        list.append(node)
