extends Node2D

var resources = \
{
    "ShipClient": Scene.SHIP,
    "AsteroidClient": Scene.ASTEROID,
    "BulletClient": Scene.BULLET
}

var input = Data.NULL_INPUT
var smoothing_rate = 0.1

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }
onready var tick = $Tick
onready var server_tick_sync = $ServerTickSync
onready var other_ships = get_parent().get_node("ExtrapolatedWorld/Ships")
onready var other_asteroids = get_parent().get_node("ExtrapolatedWorld/Asteroids")
onready var other_bullets = get_parent().get_node("ExtrapolatedWorld/Bullets")
onready var other_containers = { "ShipClient": other_ships, "AsteroidClient": other_asteroids, "BulletClient": other_bullets }

func create_player(_input): pass
func delete_player(_input): pass

func _process(_delta):
    for i in range(containers.size()):
        var container = containers.values()[i]
        var other_container = other_containers.values()[i]
        if container.get_child_count() != other_container.get_child_count():
            continue
        for j in range(container.get_child_count()):
            var child = container.get_child(j)
            var other_child = other_container.get_child(j)
            if child.has_method("linear_interpolate"):
                child.linear_interpolate(other_child, smoothing_rate)

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
            child.collision_layer = Data.get_physics_layer_id_by_name("client")
            child.collision_mask = Data.get_physics_layer_id_by_name("client")
            child.set_meta("created_this_frame", true)
            containers[type].add_child(child)

        for i in range(count):
            var child = container.get_child(i)
            var position = deserialize_Vector2(items, x); x += 2
            var rotation = deserialize_float(items, x); x += 1
            var scale = deserialize_Vector2(items, x); x += 2
            var linear_velocity = deserialize_Vector2(items, x); x += 2
            var angular_velocity = deserialize_float(items, x); x += 1
            
            if (child.has_meta("created_this_frame")):
                child.remove_meta("created_this_frame")
                if not child is Ship:
                    child.position = position
                    child.rotation = rotation
                child.scale = scale
                child.linear_velocity = linear_velocity
                child.angular_velocity = angular_velocity

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])
