extends Node2D

export var enable = true
export var smoothing_rate = 0.15

var tick = 0
var objects = []
var ship_id = -1
var input = InputData.new()
var server_tick_sync
var last_received_tick = 0
var misses = 0
var received_data
var types = {
    "Ship": Scene.SHIP,
    "Asteroid": Scene.ASTEROID,
    "Bullet": Scene.BULLET }
var creation_list = []
var deletion_list = []
var remove_from_tree_queue = []
var local_id = 1

onready var collision_manager = $CollisionManager
onready var screen_size = get_viewport().get_visible_rect().size 
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(delta):
    if received_data:
        process_received_data()
    
    if server_tick_sync.smooth_tick_rounded <= tick:
        return
    
    tick = server_tick_sync.smooth_tick_rounded
    input.record(tick)
    var ship = lookup(objects, "id", ship_id)
    if ship: 
        ship.input = input
    for object in objects:
        object.simulate(delta)
        object.record(tick)
    for item in creation_list:
        if item.object && not objects.has(item.object):
            item.object.simulate(delta)
            item.object.record(tick)
    collision_manager.resolve()
    remove_queued_from_tree()

func process_received_data():
    if received_data.tick < last_received_tick:
        return
    else:
        last_received_tick = received_data.tick
   
    ship_id = received_data.client.ship_id
    create_new_objects(received_data)
    remove_deleted_objects(received_data)
    
    for i in range(creation_list.size() - 1, -1, -1):
        if creation_list[i].tick < received_data.tick:
            if creation_list[i].id == -1:
                if creation_list[i].object:
                    creation_list[i].object.queue_free()
            creation_list.remove(i)
    
    for i in range(deletion_list.size() - 1, -1, -1):
        if deletion_list[i].tick < received_data.tick:
            deletion_list.remove(i)
    
    var is_miss = false
    for object in objects:
        if object.id == -1:
            continue
        if not object.history.has(received_data.tick):
            is_miss = true
            break
        else:
            var historic_object = null
            if object.has_node("History"):
                historic_object = object.history.history[received_data.tick]
            else:
                historic_object = object.history[received_data.tick]
            var other_object = lookup(received_data.objects, "id", object.id)
            if not other_object:
                continue
            var delta = get_delta(historic_object, other_object)
            if delta.position.length() >= 2 || delta.rotation >= 0.05:
                is_miss = true
                break
    
    for object in objects:
        object.erase_history(received_data.tick)
    
    if is_miss:
        misses += 1
        #to_log("Rewind", received_data.tick, historical_state.input, historical_state.objects)
        for object in objects:
            object.rewind(received_data.tick)
        #to_log("Rewrite", historical_state.tick, historical_state.input, historical_state.objects)
        for object in objects:
            var correct_values = lookup(received_data.objects, "id", object.id)
            if correct_values:
                object.from_dictionary(correct_values)
        #to_log("Resimulate", historical_state2.tick, historical_state2.input, historical_state2.objects)
        for resimulate_tick in range(received_data.tick + 1, server_tick_sync.smooth_tick + 1):
            input.rewind(resimulate_tick)
            var ship = lookup(objects, "id", ship_id)
            if ship:
                ship.input = input
            for object in objects:
                object.simulate(Settings.tick_rate)
                object.record(resimulate_tick)

func get_delta(source, target):
    var delta = {}
    if "position" in source && "position" in target:
        var delta_x = target.position.x - source.position.x
        if abs(target.position.x - (source.position.x + screen_size.x)) < abs(delta_x):
            delta_x = target.position.x - (source.position.x + screen_size.x)
        if abs(target.position.x - (source.position.x - screen_size.x)) < abs(delta_x):
            delta_x = target.position.x - (source.position.x - screen_size.x)
        var delta_y = target.position.y - source.position.y
        if abs(target.position.y - (source.position.y + screen_size.y)) < abs(delta_y):
            delta_y = target.position.y - (source.position.y + screen_size.y)
        if abs(target.position.y - (source.position.y - screen_size.y)) < abs(delta_y):
            delta_y = target.position.y - (source.position.y - screen_size.y)
        delta["position"] = Vector2(delta_x, delta_y)
    if "rotation" in source && "rotation" in target:
        var delta_rotation = target.rotation - source.rotation
        if abs(target.rotation - (source.rotation - 2 * PI)) < abs(delta_rotation):
            delta_rotation = target.rotation - (source.rotation - 2 * PI)
        if abs(target.rotation - (source.rotation - 2 * PI)) < abs(delta_rotation):
            delta_rotation = target.rotation - (source.rotation - 2 * PI)
        delta["rotation"] = delta_rotation
    if "scale" in source && "scale" in target:
        delta["scale"] = target.scale - source.scale
    if "linear_velocity" in source && "linear_velocity" in target:
        delta["linear_velocity"] = target.linear_velocity - source.linear_velocity
    if "angular_velocity" in source && "angular_velocity" in target:
        delta["angular_velocity"] = target.angular_velocity - source.angular_velocity
    return delta

func apply_delta(source, delta):
    if source is Node && source.has_method("apply_delta"):
        source.apply_delta(delta)
        return
    
    if "position" in source && "position" in delta:
        source["position"] += delta.position
    if "rotation" in source && "rotation" in delta:
        source["rotation"] += delta.rotation
    if "scale" in source && "scale" in delta:
        source["scale"] += delta.scale
    if "linear_velocity" in source && "linear_velocity" in delta:
        source["linear_velocity"] += delta.linear_velocity
    if "angular_velocity" in source && "angular_velocity" in delta:
        source["angular_velocity"] += delta.angular_velocity

func create_new_objects(dictionary):
    for entry in dictionary.objects:
        if entry:
            var object = lookup(objects, "id", entry.id)
            var on_deletion_list = lookup(deletion_list, "id", entry.id)
#            if on_deletion_list && dictionary.tick > on_deletion_list.tick:
#                on_deletion_list.object.recreate()
#                on_deletion_list.object.from_dictionary(entry)
#                objects.append(on_deletion_list.object)
#                deletion_list.erase(on_deletion_list)
#            elif ...
            if not object && not on_deletion_list:
                create_object(entry)

func remove_deleted_objects(dictionary):
    for i in range(objects.size() - 1, -1, -1):
        var object = objects[i]
        if not lookup(dictionary.objects, "id", object.id):
            objects.remove(i)
            object.queue_free()
    
    for i in range(deletion_list.size() - 1, -1, -1):
        var delete_item = deletion_list[i]
        if not lookup(dictionary.objects, "id", delete_item.id):
            if delete_item.object:
                delete_item.object.queue_free()
            deletion_list.remove(i)

func create_object(entry):
    var type = entry.type
    var object = claim_new_object(entry)
    if not object:
        object = types[type].instance()
        object.collision_layer = Data.get_physics_layer_id_by_name("predicted_world")
        object.collision_mask = Data.get_physics_layer_id_by_name("predicted_world")
        object.connect("tree_exited", self, "erase_object", [object])
        objects.append(object)
        containers[type].add_child(object)
        if "physics" in object: object.physics.collision_manager = collision_manager
        object.from_dictionary(entry)
        if type == "Bullet" && "ship_id" in entry:
            var ship = lookup(objects, "id", ship_id)
            if ship:
                object.add_collision_exception_with(ship)
        if object.has_signal("bullet_created"):
            object.connect("bullet_created", self, "create_bullet")

func erase_object(object):
    var created_object = lookup(creation_list, "object", object)
    var created_local_id = created_object.local_id if created_object else -1
    CSV.write_line("res://object.csv", ["p_erase",tick,object.id,created_local_id,object.position,object.rotation])
    deletion_list.append({"tick": tick, "id": object.id, "local_id": created_local_id, "object": object})
    objects.erase(object)

func lookup(list, key, value):
    for item in list:
        if item:
            if key in item:
                if item[key] == value:
                    return item
    return null

func to_dictionary():
    var objects = []
    for object in objects:
        objects.append(object.to_dictionary())
    var input_dict = inst2dict(input)
    return {"tick": tick, "input": input_dict, "objects": objects}

func claim_new_object(entry):
    var closest = { "distance": 1000000, "unclaimed": null }
    for unclaimed in creation_list:
        if unclaimed.id == -1:
            var distance = (entry.create_position - unclaimed.create_position).length()
            if distance < closest.distance:
                closest = { "distance": distance, "unclaimed": unclaimed }
    
    if closest.unclaimed:
        closest.unclaimed.id = entry.id
        var deleted_object = lookup(deletion_list, "local_id", closest.unclaimed.local_id)
        if deleted_object:
            deleted_object.id = entry.id
        
        var object = closest.unclaimed.object
        if object:
            object.id = entry.id
            objects.append(object)
            CSV.write_line("res://object.csv", ["p_sync",tick,closest.unclaimed.id,closest.unclaimed.local_id,object.position,object.rotation])
            return object
        else:
            return true

func create_bullet(bullet):
    local_id += 1
    bullet.collision_layer = Data.get_physics_layer_id_by_name("predicted_world")
    bullet.collision_mask = Data.get_physics_layer_id_by_name("predicted_world")
    bullet.connect("tree_exited", self, "erase_object", [bullet])
    
    for other_bullet in $Bullets.get_children():
        if other_bullet is KinematicBody2D:
            bullet.add_collision_exception_with(other_bullet)
    
    $Bullets.add_child(bullet)
    bullet.physics.collision_manager = collision_manager
    bullet.record(tick)
    creation_list.append({"tick": tick, "id": -1, "local_id": local_id, "object": bullet, "create_position": bullet.global_position})
    CSV.write_line("res://object.csv", ["p_create",tick,bullet.id,local_id-1,bullet.position,bullet.rotation])
    debug_bullet_create(bullet)

func debug_bullet_create(bullet):
    bullet.connect("tree_exited", self, "debug_bullet_destroy", [bullet])
    CSV.write_line("res://bullet.csv", [tick, "client_create_bullet"])

func debug_bullet_destroy(_bullet):
    CSV.write_line("res://bullet.csv", [tick, "client_destroy_bullet"])

func queue_remove_from_tree(child):
    remove_from_tree_queue.append(child)

func remove_queued_from_tree():
    for node in remove_from_tree_queue:
        node.get_parent().remove_child(node)
