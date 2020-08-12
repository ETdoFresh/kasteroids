extends Node2D

var types = \
{
    "ShipClient": Scene.SHIP_CLIENT,
    "AsteroidClient": Scene.ASTEROID_CLIENT,
    "BulletClient": Scene.BULLET_CLIENT
}

var dictionary = {}
var input = Data.NULL_INPUT
var last_tick_received = 0
var server_tick_sync

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }

func simulate(_delta):
    return
    if not server_tick_sync:
        return
    
    var time = (server_tick_sync.smooth_tick - last_tick_received) * Settings.tick_rate
    for type in containers.values():
        for child in type.get_children():
            if child.has_meta("extrapolated_position"):
                child.position = child.get_meta("extrapolated_position")
                child.position += child.get_meta("linear_velocity") * time
                child.rotation = child.get_meta("extrapolated_rotation")
                child.rotation += child.get_meta("angular_velocity") * time

func deserialize(serialized):
    dictionary = parse_json(serialized)
    return 
    
    var queue = PoolStringQueue.new(serialized.split(",", false))
    var server_tick = Data.deserialize_int(queue)
    var _client_tick = Data.deserialize_int(queue)
    var _offset_time = Data.deserialize_float(queue)
    
    if server_tick < last_tick_received:
        return
    else:
        last_tick_received = server_tick
    
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
            child.set_meta("extrapolated_position", child.data.position)
            child.set_meta("extrapolated_rotation", child.data.rotation)
            child.set_meta("linear_velocity", child.data.linear_velocity)
            child.set_meta("angular_velocity", child.data.angular_velocity)
