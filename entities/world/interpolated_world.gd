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

func _process(_delta):
    tick.tick = server_tick_sync.interpolated_tick
    $Interpolation.interpolate(tick.tick)

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = ["ShipClient", "AsteroidClient", "BulletClient"]
    var x = 0
    
    var server_tick = int(items[x]); x += 1
    var client_tick = int(items[x]); x += 1
    var offset_time = float(items[x]); x += 1
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    var state = {"tick": server_tick, "children": []}
    for type in types:
        var count = int(items[x]); x += 1
        
        ## TODO: Maybe move this section to interpolation (Add/Delete Nodes)
        var container = containers[type]
        while container.get_child_count() > count:
            container.get_child(0).free()
        while container.get_child_count() < count:
            var child = resources[type].instance()
            containers[type].add_child(child)

        for i in range(count):
            var child = container.get_child(i)
            var position = deserialize_Vector2(items, x); x += 2
            var rotation = deserialize_float(items, x); x += 1
            var scale = deserialize_Vector2(items, x); x += 2
            var linear_velocity = deserialize_Vector2(items, x); x += 2
            var angular_velocity = deserialize_float(items, x); x += 1
            
            state.children.append({
                "node": child, 
                "position": position, 
                "rotation": rotation, 
                "scale": scale,
                "linear_velocity": linear_velocity,
                "angular_velocity": angular_velocity
            })
    $Interpolation.add_history(state)

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])
