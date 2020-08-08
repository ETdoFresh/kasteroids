extends Node2D

var types = \
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
        for j in range(container.get_child_count()):
            var child = container.get_child(j)
            var data = child.find_node("Data")
            var id = data.id
            var other_child = get_child_by_id(other_container, id)
            if other_child != null:
                if child.has_method("linear_interpolate"):
                    child.linear_interpolate(other_child, smoothing_rate)

func deserialize(serialized):
    var items = serialized.split(",", false)
    var type_names = containers.keys()
    var x = 0
    
    var server_tick = int(items[x]); x += 1
    var client_tick = int(items[x]); x += 1
    var offset_time = float(items[x]); x += 1
    if tick:
        tick.tick = server_tick
    if server_tick_sync:
        $ServerTickSync.record_client_recieve(server_tick, client_tick, offset_time)
    
    for type_name in type_names:
        var count = int(items[x]); x += 1
        var container = containers[type_name]
        var type = types[type_name]

        var ids = []
        for _i in range(count):
            var id = deserialize_int(items, x); x += 1
            var _position = deserialize_Vector2(items, x); x += 2
            var _rotation = deserialize_float(items, x); x += 1
            var _scale = deserialize_Vector2(items, x); x += 2
            var linear_velocity = deserialize_Vector2(items, x); x += 2
            var angular_velocity = deserialize_float(items, x); x += 1
            
            ids.append(id)
            if not container_has_id(container, id):
                create_instance(container, type, id)
            
            var child = get_child_by_id(container, id)
            child.linear_velocity = linear_velocity
            child.angular_velocity = angular_velocity
        
        for child in container.get_children():
            var data = child.find_node("Data")
            if not ids.has(data.id):
                child.queue_free()

func deserialize_int(items, x):
    return int(items[x])

func deserialize_float(items, x):
    return float(items[x])

func deserialize_Vector2(items, x):
    return Vector2(items[x], items[x + 1])

func create_instance(container, type, id):
    var child = type.instance()
    child.collision_layer = Data.get_physics_layer_id_by_name("client")
    child.collision_mask = Data.get_physics_layer_id_by_name("client")
    child.set_meta("created_this_frame", true)
    var data = child.find_node("Data")
    container.add_child(child)
    data.id = id
    return child

func get_child_by_id(container, id):
    for child in container.get_children():
        var data = child.find_node("Data")
        if data.id == id:
            return child
    return null

func container_has_id(container, id):
    for child in container.get_children():
        var data = child.find_node("Data")
        if data.id == id:
            return true
    return false

func delete_instances(before, after):
    var ids = []
    for child in before.children: ids.append(child.id)
    for child in after.children: ids.append(child.id)
    for container in before.containers:
        for child in container.get_children():
            var data = child.find_node("Data")
            if data && ids.has(data.id):
                continue
            else:
                child.queue_free()
