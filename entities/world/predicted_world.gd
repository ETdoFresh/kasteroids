extends Node2D

var types = \
{
    "ShipClient": Scene.SHIP,
    "AsteroidClient": Scene.ASTEROID,
    "BulletClient": Scene.BULLET
}

var input = Data.NULL_INPUT
var smoothing_rate = 0.1
var server_tick_sync
var last_received_tick = 0

onready var containers = { "ShipClient": $Ships, "AsteroidClient": $Asteroids, "BulletClient": $Bullets }
onready var other_ships = get_parent().get_node("ExtrapolatedWorld/Ships")
onready var other_asteroids = get_parent().get_node("ExtrapolatedWorld/Asteroids")
onready var other_bullets = get_parent().get_node("ExtrapolatedWorld/Bullets")
onready var other_containers = { "ShipClient": other_ships, "AsteroidClient": other_asteroids, "BulletClient": other_bullets }
onready var place_holder_data = $PlaceHolderData

func simulate(_delta):
    for i in range(containers.size()):
        var container = containers.values()[i]
        var other_container = other_containers.values()[i]
        for j in range(container.get_child_count()):
            var child = container.get_child(j)
            var other_child = get_child_by_id(other_container, child.data.id)
            if other_child != null:
                if child.has_method("linear_interpolate"):
                    child.linear_interpolate(other_child, smoothing_rate)

func deserialize(serialized):
    var queue = PoolStringQueue.new(serialized.split(",", false))
    var server_tick = Data.deserialize_int(queue)
    var _client_tick = Data.deserialize_int(queue)
    var _offset_time = Data.deserialize_float(queue)
    
    if server_tick < last_received_tick:
        return
    else:
        last_received_tick = server_tick
    
    for type_name in types.keys():
        var count = Data.deserialize_int(queue)
        var container = containers[type_name]
        var type = types[type_name]
        
        var ids = []
        for _i in range(count):
            place_holder_data.deserialize(queue)
            
            var id = place_holder_data.id
            ids.append(id)
            if not container_has_id(container, id):
                create_instance(container, type, id)
            
            # TODO: Compare to determine if there was a prediction miss.
            
            var child = get_child_by_id(container, id)
            child.linear_velocity = place_holder_data.linear_velocity
            child.angular_velocity = place_holder_data.angular_velocity
            child.data.instance_name = place_holder_data.instance_name
        
        for child in container.get_children():
            if not ids.has(child.data.id):
                child.queue_free()

func create_instance(container, type, id):
    var child = type.instance()
    child.collision_layer = Data.get_physics_layer_id_by_name("client")
    child.collision_mask = Data.get_physics_layer_id_by_name("client")
    container.add_child(child)
    child.data.id = id
    return child

func get_child_by_id(container, id):
    for child in container.get_children():
        if child.data.id == id:
            return child
    return null

func container_has_id(container, id):
    for child in container.get_children():
        if child.data.id == id:
            return true
    return false
