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

func _process(_delta):
    tick.tick = server_tick_sync.interpolated_tick
    $Interpolation.interpolate(tick.tick)

func deserialize(serialized):
    var items = serialized.split(",", false)
    var type_names = ["ShipClient", "AsteroidClient", "BulletClient"]
    var x = 0
    
    var server_tick = int(items[x]); x += 1
    var client_tick = int(items[x]); x += 1
    var offset_time = float(items[x]); x += 1
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    var state = {"tick": server_tick, "containers": containers.values(), "children": []}
    for type_name in type_names:
        var count = int(items[x]); x += 1
        var type = types[type_name]
        var container = containers[type_name]
        for _i in range(count):
            var id = deserialize_int(items, x); x += 1
            var position = deserialize_Vector2(items, x); x += 2
            var rotation = deserialize_float(items, x); x += 1
            var scale = deserialize_Vector2(items, x); x += 2
            var linear_velocity = deserialize_Vector2(items, x); x += 2
            var angular_velocity = deserialize_float(items, x); x += 1
            
            var child
            for container_child in container.get_children():
                var data = container_child.find_node("Data")
                if data.id == id:
                    child = container_child
                    break
            
            state.children.append({
                "node": child,
                "id": id,
                "container": container,
                "type": type,
                "position": position, 
                "rotation": rotation, 
                "scale": scale,
                "linear_velocity": linear_velocity,
                "angular_velocity": angular_velocity
            })
    $Interpolation.add_history(state)

func deserialize_int(items, x):
    return int(items[x])

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])
