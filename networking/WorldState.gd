extends Node

export var ship_client_scene = preload("res://entities/Ship/ShipClient.tscn")
export var asteroid_client_scene = preload("res://entities/Asteroid/AsteroidClient.tscn")
export var bullet_client_scene = preload("res://entities/Bullet/BulletClient.tscn")

export var server_nodes = []
export var server_message = ""

export var client_nodes = []
export var client_message = ""

func _enter_tree():
    server_nodes = []
    client_nodes = []
    
    #warning-ignore:return_value_discarded
    Global.connect("node_created", self, "add_node")
    
    #warning-ignore:return_value_discarded
    Global.connect("node_destroyed", self, "remove_node")

func _exit_tree():
    #warning-ignore:return_value_discarded
    Global.disconnect("node_created", self, "add_node")
    
    #warning-ignore:return_value_discarded
    Global.disconnect("node_destroyed", self, "remove_node")

func add_node(node):
    server_nodes.append(node)

func remove_node(node):
    for i in range(server_nodes.size() - 1, -1, -1):
        if (server_nodes[i] == node):
            server_nodes.remove(i)

func serialize():
    server_message = ""
    
    var types = [Ship, Asteroid, Bullet]
    for type in types:
        var count = 0
        for node in server_nodes: if node is type: count += 1
        server_message += String(count) + ","
        for node in server_nodes:
            if node is type:
                server_message += String(node.position.x) + ","
                server_message += String(node.position.y) + ","
                server_message += String(node.rotation) + ","
                server_message += String(node.scale.x) + ","
                server_message += String(node.scale.y) + ","
    
    return server_message

func deserialize(message):
    client_message = message
    var items = message.split(",", false)
    var types = [ShipClient, AsteroidClient, BulletClient]
    var x = 0
        
    for type in types:
        var count = int(items[x]); x += 1
        while count_nodes_by_type(client_nodes, type) > count:
            remove_node_by_type(client_nodes, type)
        
        while count_nodes_by_type(client_nodes, type) < count:
            add_node_by_type(client_nodes, type)
        
        for i in range(count):
            var node = get_node_by_type(client_nodes, type, i)
            node.position.x = float(items[x]); x += 1
            node.position.y = float(items[x]); x += 1
            node.rotation = float(items[x]); x += 1
            node.scale.x = float(items[x]); x += 1
            node.scale.y = float(items[x]); x += 1

func count_nodes_by_type(nodes, type):
    var count = 0
    for node in nodes:
        if node is type:
            count += 1
    return count

func remove_node_by_type(nodes, type):
    for i in range(nodes.size()):
        if nodes[i] is type:
            nodes[i].queue_free()
            nodes.remove(i)
            return

func add_node_by_type(nodes, type):
    
    var node = null
    if type == ShipClient:
        node = ship_client_scene.instance()
    elif type == AsteroidClient:
        node = asteroid_client_scene.instance()
    elif type == BulletClient:
        node = bullet_client_scene.instance()
        
    if node != null:
        get_tree().get_root().add_child(node)
        nodes.append(node)

func get_node_by_type(nodes, type, i):
    var j = 0
    for node in nodes:
        if node is type:
            if j == i:
                return node
            else:
                j += 1
                
    return null
