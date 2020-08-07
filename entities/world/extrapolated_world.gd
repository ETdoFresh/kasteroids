extends Node2D

var resources = \
{
    "ShipClient": Scene.SHIP_CLIENT,
    "AsteroidClient": Scene.ASTEROID_CLIENT,
    "BulletClient": Scene.BULLET_CLIENT
}

var input = Data.NULL_INPUT
var last_tick_received = 0

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }
onready var tick = $Tick
onready var server_tick_sync = $ServerTickSync

func create_player(_input): pass
func delete_player(_input): pass

func _process(_delta):
    var time = ($ServerTickSync.smooth_tick - last_tick_received) * $ServerTickSync.tick_rate
    for type in containers.values():
        for child in type.get_children():
            if child.has_meta("extrapolated_position"):
                child.position = child.get_meta("extrapolated_position")
                child.position += child.get_meta("linear_velocity") * time
                child.rotation = child.get_meta("extrapolated_rotation")
                child.rotation += child.get_meta("angular_velocity") * time

func deserialize(serialized):
    var items = serialized.split(",", false)
    var types = containers.keys()
    var x = 0
    
    var server_tick = int(items[x]); x += 1
    var client_tick = int(items[x]); x += 1
    var offset_time = float(items[x]); x += 1    
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    if server_tick < last_tick_received:
        return
    
    last_tick_received = server_tick
    
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
            child.position = deserialize_Vector2(items, x); x += 2
            child.set_meta("extrapolated_position", child.position)
            child.rotation = deserialize_float(items, x); x += 1
            child.set_meta("extrapolated_rotation", child.rotation)
            child.scale = deserialize_Vector2(items, x); x += 2
            child.set_meta("linear_velocity", deserialize_Vector2(items, x)); x += 2
            child.set_meta("angular_velocity", deserialize_float(items, x)); x += 1

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])
