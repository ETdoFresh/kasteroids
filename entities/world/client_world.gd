extends Node2D

var resources = \
{
    "ShipClient": Scene.SHIP_CLIENT,
    "AsteroidClient": Scene.ASTEROID_CLIENT,
    "BulletClient": Scene.BULLET_CLIENT
}

var input = Data.NULL_INPUT

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }
onready var tick = $Tick
onready var server_tick_sync = $ServerTickSync

func create_player(_input): pass
func delete_player(_input): pass

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = containers.keys()
    var x = 0
    
    var server_tick = int(items[x]); x += 1
    var client_tick = int(items[x]); x += 1
    var offset_time = float(items[x]); x += 1
    if tick:
        tick.tick = server_tick
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
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
            var _id = deserialize_int(items, x); x += 1
            child.position = deserialize_Vector2(items, x); x += 2
            child.rotation = deserialize_float(items, x); x += 1
            child.scale = deserialize_Vector2(items, x); x += 2
            var _linear_velocity = deserialize_Vector2(items, x); x += 2
            var _angular_velocity = deserialize_float(items, x); x += 1

func deserialize_int(items, x):
    return int(items[x])

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])
