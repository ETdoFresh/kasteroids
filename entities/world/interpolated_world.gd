extends Node2D

var types = \
{
    "ShipClient": Scene.SHIP_CLIENT,
    "AsteroidClient": Scene.ASTEROID_CLIENT,
    "BulletClient": Scene.BULLET_CLIENT
}

var dictionary = {}
var input = Data.NULL_INPUT
var server_tick_sync

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }
onready var place_holder_data = $PlaceHolderData

func simulate(_delta):
    return
    if server_tick_sync:
        var tick = server_tick_sync.smooth_tick_rounded
        var rtt = server_tick_sync.rtt
        var receive_rate = server_tick_sync.receive_rate
        var interpolated_tick = $Interpolation.get_interpolated_tick(tick, rtt, receive_rate)
        $Interpolation.interpolate(interpolated_tick)

func deserialize(serialized):
    dictionary = parse_json(serialized)
    return 
    
    var queue = PoolStringQueue.new(serialized.split(",", false))
    var server_tick = Data.deserialize_int(queue)
    var _client_tick = Data.deserialize_int(queue)
    var _offset_time = Data.deserialize_float(queue)
    
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
