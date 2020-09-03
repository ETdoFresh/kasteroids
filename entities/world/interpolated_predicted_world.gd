extends Node2D

export var enable = true
export var smoothing_rate = 0.15
export var snapping_distance = 200

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
var create_list = []
var delete_list = []
var local_id = 0

onready var predicted_world = get_parent().get_node("PredictedWorld")
onready var collision_manager = $CollisionManager
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(delta):
    tick = server_tick_sync.smooth_tick_rounded
    var ship = lookup(entity_list, "id", ship_id)
    if ship: 
        ship.input = input
    for entity in entity_list:
        entity.simulate(delta)
    for item in create_list:
        if item.entity:
            item.entity.simulate(delta)
    collision_manager.resolve()
    
    for entity in entity_list:
        var other_entity = lookup(predicted_world.entity_list, "id", entity.id)
        if not other_entity:
            continue
        var interpolation_rate = 0.2
        var a = entity.to_dictionary()
        var b = other_entity.to_dictionary()
        var new_position
        if (a.position - b.position).length() < snapping_distance:
            new_position = a.position.linear_interpolate(b.position, interpolation_rate)
        else:
            new_position = b.position
        entity.from_dictionary({
            "position": new_position,
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
    
    for i in range(create_list.size() - 1, -1, -1):
        if create_list[i].tick < received.tick:
            if create_list[i].id == -1:
                if create_list[i].entity:
                    create_list[i].entity.queue_free()
            create_list.remove(i)
    
    for i in range(delete_list.size() - 1, -1, -1):
        if delete_list[i].tick < received.tick:
            delete_list.remove(i)

func create_new_entities(dictionary):
    for entry in dictionary.objects:
        if entry:
            var entity = lookup(entity_list, "id", entry.id)
            var on_delete_list = lookup(delete_list, "id", entry.id)
            if not entity && not on_delete_list:
                create_entity(entry)

func remove_deleted_entities(dictionary):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not lookup(dictionary.objects, "id", entity.id):
            entity_list.remove(i)
            entity.queue_free()

func create_entity(entry):
    var type = entry.type
    var entity = claim_new_entity(entry)
    if not entity:
        entity = types[type].instance()
        entity_list.append(entity)
        entity.collision_layer = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
        entity.collision_mask = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
        entity.connect("tree_exited", self, "erase_entity", [entity])
        containers[type].add_child(entity)
        if "physics" in entity: entity.physics.collision_manager = collision_manager
        entity.from_dictionary(entry)
        if type == "Bullet" && "ship_id" in entry:
            var ship = lookup(entity_list, "id", ship_id)
            if ship:
                entity.add_collision_exception_with(ship)
        if entity.has_signal("bullet_created"):
            entity.connect("bullet_created", self, "create_bullet")

func erase_entity(entity):
    var created_entity = lookup(create_list, "entity", entity)
    var created_local_id = created_entity.local_id if created_entity else -1
    delete_list.append({"tick": tick, "id": entity.id, "local_id": created_local_id})
    entity_list.erase(entity)

func lookup(list, key, value):
    for item in list:
        if item:
            if key in item:
                if item[key] == value:
                    return item
    return null

func claim_new_entity(entry):
    var unclaimed = lookup(create_list, "id", -1)
    if unclaimed:
        unclaimed.id = entry.id
        var deleted_entity = lookup(delete_list, "local_id", unclaimed.local_id)
        if deleted_entity:
            deleted_entity.id = entry.id
        
        var entity = unclaimed.entity
        if entity:
            entity.id = entry.id
            entity_list.append(entity)
            return entity
        else:
            return true

func create_bullet(bullet):
    create_list.append({"tick": tick, "id": -1, "local_id": local_id, "entity": bullet})
    local_id += 1
    bullet.collision_layer = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
    bullet.collision_mask = Data.get_physics_layer_id_by_name("interpolated_predicted_world")
    bullet.connect("tree_exited", self, "erase_entity", [bullet])
    
    for other_bullet in $Bullets.get_children():
        if other_bullet is KinematicBody2D:
            bullet.add_collision_exception_with(other_bullet)
    
    $Bullets.add_child(bullet)
    bullet.physics.collision_manager = collision_manager
