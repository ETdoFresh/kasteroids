extends Node2D

var resources = \
{
    ShipClient: Scene.SHIP_CLIENT,
    AsteroidClient: Scene.ASTEROID_CLIENT,
    BulletClient: Scene.BULLET_CLIENT
}

var input = Data.NULL_INPUT

onready var containers = { ShipClient: $Ships, AsteroidClient: $Asteroids, BulletClient: $Bullets }
onready var tick = $Tick

func create_player(_input): pass
func delete_player(_input): pass

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = [ShipClient, AsteroidClient, BulletClient]
    var x = 0
    
    tick.tick = int(items[x]); x += 1
    for type in types:
        var count = int(items[x]); x += 1
        var container = containers[type]
        while container.get_child_count() > count:
            container.get_child(0).free()

        while container.get_child_count() < count:
            var child = resources[type].instance()
            containers[type].add_child(child)

        for i in range(count):
            var child = container.get_child(i)
            var position = Vector2()
            position.x = float(items[x]); x += 1
            position.y = float(items[x]); x += 1
            var rotation = float(items[x]); x += 1
            var scale = Vector2()
            scale.x = float(items[x]); x += 1
            scale.y = float(items[x]); x += 1
            
            if child.has_method("receive_update"):
                child.receive_update({"tick": 0, "position": position, "rotation": rotation, "scale": scale})
            else:
                child.position = position
                child.rotation = rotation
                child.scale = scale
