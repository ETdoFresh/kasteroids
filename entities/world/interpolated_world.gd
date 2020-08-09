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
onready var place_holder_data = $PlaceHolderData

func create_player(_input): pass
func delete_player(_input): pass

func _process(_delta):
    tick.tick = server_tick_sync.interpolated_tick
    $Interpolation.interpolate(tick.tick)

func deserialize(serialized):
    var queue = PoolStringQueue.new(serialized.split(",", false))
    var server_tick = Data.deserialize_int(queue)
    var client_tick = Data.deserialize_int(queue)
    var offset_time = Data.deserialize_float(queue)
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    var state = {"tick": server_tick, "containers": containers.values(), "children": []}
    for type_name in types.keys():
        var count = Data.deserialize_int(queue)
        var type = types[type_name]
        var container = containers[type_name]
        for _i in range(count):
            place_holder_data.deserialize(queue)
            
            var child
            for container_child in container.get_children():
                var data = container_child.find_node("Data")
                if data.id == place_holder_data.id:
                    child = container_child
                    break
            
            state.children.append({
                "node": child,
                "id": place_holder_data.id,
                "container": container,
                "type": type,
                "position": place_holder_data.position, 
                "rotation": place_holder_data.rotation, 
                "scale": place_holder_data.scale,
                "linear_velocity": place_holder_data.linear_velocity,
                "angular_velocity": place_holder_data.angular_velocity
            })
    $Interpolation.add_history(state)
