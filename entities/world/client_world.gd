extends Node2D

var types = \
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
    var queue = PoolStringQueue.new(serialized.split(",", false))    
    var server_tick = Data.deserialize_int(queue)
    var client_tick = Data.deserialize_int(queue)
    var offset_time = Data.deserialize_float(queue)
    
    if tick:
        tick.tick = server_tick
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    for type_name in types.keys():
        var count = Data.deserialize_int(queue)
        var container = containers[type_name]
        
        while container.get_child_count() > count:
            container.get_child(0).free()
        while container.get_child_count() < count:
            var child = types[type_name].instance()
            containers[type_name].add_child(child)

        for i in range(count):
            var child = container.get_child(i)
            child.data.deserialize(queue)
