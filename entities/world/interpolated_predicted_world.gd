extends Node2D

export var enable = true
export var smoothing_rate = 0.15

var tick = 0
var entity_list = []
var ship_id = -1
var input = InputData.new()
var server_tick_sync
var last_received_tick = 0
var types = {
    "Ship": Scene.SHIP,
    "Asteroid": Scene.ASTEROID,
    "Bullet": Scene.BULLET }

onready var predicted_world = get_parent().get_node("PredictedWorld")
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(delta):
    tick = server_tick_sync.smooth_tick_rounded
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.update_input(input)
    for entity in entity_list:
        entity.simulate(delta)
    
    for entity in entity_list:
        var other_entity = lookup(predicted_world.entity_list, "id", entity.id)
        if not other_entity:
            continue
        var interpolation_rate = 0.2
        var a = entity.to_dictionary()
        var b = other_entity.to_dictionary()
        entity.from_dictionary({
            "position": a.position.linear_interpolate(b.position, interpolation_rate),
            "rotation": lerp_angle(a.rotation, b.rotation, interpolation_rate),
            "linear_velocity": a.linear_velocity.linear_interpolate(b.linear_velocity, interpolation_rate),
            "angular_velocity": lerp(a.angular_velocity, b.angular_velocity, interpolation_rate),
            "scale": b.scale })

func receive(received):
    if received.tick < last_received_tick:
        return
    else:
        last_received_tick = received.tick
   
    ship_id = received.client.ship_id
    create_new_entities(received)
    remove_deleted_entities(received)

func create_new_entities(dictionary):
    for entry in dictionary.objects:
        var entity = lookup(entity_list, "id", entry.id)
        if not entity:
            create_entity(entry)

func remove_deleted_entities(dictionary):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not lookup(dictionary.objects, "id", entity.id):
            entity_list.remove(i)
            entity.queue_free()

func create_entity(entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    entity.collision_layer = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
    entity.collision_mask = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
    entity.connect("tree_exited", self, "erase_entity", [entity])
    entity.from_dictionary(entry)
    containers[type].add_child(entity)

func erase_entity(entity):
    entity_list.erase(entity)

func lookup(list, key, value):
    for item in list:
        if key in item:
            if item[key] == value:
                return item
    return null
