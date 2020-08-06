extends Node2D

const resources = \
{
    ShipClient: preload("res://entities/ship/ship_client.tscn"),
    AsteroidClient: preload("res://entities/asteroid/asteroid_client.tscn"),
    BulletClient: preload("res://entities/bullet/bullet_client.tscn")
}

var input = Util.NULL_INPUT

onready var containers = { ShipClient: $Ships, AsteroidClient: $Asteroids, BulletClient: $Bullets }

func create_player(_input): pass
func delete_player(_input): pass

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = [ShipClient, AsteroidClient, BulletClient]
    var x = 0

    for type in types:
        var count = int(items[x]); x += 1
        var nodes = containers[type].nodes
        while nodes.size() > count:
            nodes[0].queue_free()
            nodes.remove(0)

        while nodes.size() < count:
            containers[type].create(resources[type])

        for i in range(count):
            var node = nodes[i]
            var position = Vector2()
            position.x = float(items[x]); x += 1
            position.y = float(items[x]); x += 1
            var rotation = float(items[x]); x += 1
            var scale = Vector2()
            scale.x = float(items[x]); x += 1
            scale.y = float(items[x]); x += 1
            
            if node.has_method("receive_update"):
                node.receive_update({"tick": 0, "position": position, "rotation": rotation, "scale": scale})
            else:
                node.position = position
                node.rotation = rotation
                node.scale = scale
