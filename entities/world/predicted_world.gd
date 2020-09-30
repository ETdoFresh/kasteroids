extends Node2D

export var enable = true
export var smoothing_rate = 0.15

var tick = 0
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
var objects = []
var creation_queue = []
var deletion_queue = []
var awaiting_delete_confirmation = []
var awaiting_create_confirmation = []

onready var collision_manager = $CollisionManager
onready var screen_size = get_viewport().get_visible_rect().size 
onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(delta):
    process_received_data(delta)
    if not is_new_tick(): return
    tick = server_tick_sync.smooth_tick_rounded
    simulate_predicted_world(delta)

func simulate_predicted_world(delta):
    update_inputs()
    simulate_objects(delta)
    record()
    remove_objects_from_tree()
    create_objects()

func process_received_data(delta):
    if not received_data:
        return
    
    if received_data.tick < last_received_tick:
        return
    else:
        last_received_tick = received_data.tick
   
    ship_id = received_data.client.ship_id
    
    var is_miss = false
    for entry in received_data.objects:
        is_miss |= is_entry_deleted(entry, received_data.tick)
        is_miss |= is_entry_not_predicted(entry)
        if is_miss: break
    
    if not is_miss:
        for object in objects:
            is_miss |= is_object_exists_with_no_entry(object, received_data)
            if is_miss: break
    
    if not is_miss:
        for entry in received_data.objects:
            is_miss |= mismatch_exceeds_threshold(entry)
            if is_miss: break
    
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
        var world
        world.rewind(received_data.tick)
        world.rewrite(received_data)
        for resimulate_tick in range(received_data.tick + 1, server_tick_sync.smooth_tick + 1):
            world.rewind(resimulate_tick)
            simulate_predicted_world(delta)
    
    confirm_created_objects(received_data)
    confirm_deleted_objects()
    received_data = null

func is_new_tick():
    return server_tick_sync.smooth_tick_rounded > tick

func update_inputs():
    var ship = lookup(objects, "id", ship_id)
    if ship: 
        ship.input = input

func simulate_objects(delta):
    for object in objects:
        object.simulate(delta)
    collision_manager.resolve()

func record():
    input.record(tick)
    for object in objects:
        object.record(tick)

func remove_objects_from_tree():
    for i in range(deletion_queue.size() - 1, -1, -1):
        var object = deletion_queue[i]
        var container = object.get_parent()
        object.get_parent().remove_child(object)
        deletion_queue.remove(i)
        awaiting_delete_confirmation.append({"tick": tick, "id": object.id, "object": object, "container": container})

func create_objects():
    for i in range(creation_queue.size() - 1, -1, -1):
        var object = creation_queue[i].object
        var container = creation_queue[i].container
        object.collision_layer = Data.get_physics_layer_id_by_name("predicted_world")
        object.collision_mask = Data.get_physics_layer_id_by_name("predicted_world")
        object.connect("tree_exited", self, "erase_object", [object])
        objects.append(object)
        container.add_child(object)
        object.physics.collision_manager = collision_manager
        creation_queue.remove(i)
        awaiting_create_confirmation.append({"tick": tick, "object": object})

func mismatch_exceeds_threshold(entry):
    var history = null
    var object = List.lookup(objects, "id", entry.id)
    if not object:
        return false
    if object.has_node("History"):
        history = object.history.history[received_data.tick]
    elif not object.history.has(received_data.tick):
        history = object.history[received_data.tick]
    else:
        return true
    
    var historic_object
    var other_object
    var delta = get_delta(historic_object, other_object)
    if delta.position.length() >= 2 || delta.rotation >= 0.05:
        return true
    else:
        return false

func is_entry_deleted(entry, received_tick):
    var awaiting_deletion = List.lookup(awaiting_delete_confirmation, "id", entry.id)
    if awaiting_deletion:
        if awaiting_deletion.tick < received_tick:
            return true
    return false

func is_entry_not_predicted(entry):
    for i in range(awaiting_create_confirmation.size()):
        var awaiting_creation = awaiting_create_confirmation[i]
        var type = types[entry.type]
        if awaiting_creation.object is type:
            if not "predicted" in awaiting_creation:
                awaiting_creation["predicted"] = true
                return false
    return true

func is_object_exists_with_no_entry(object, received_data):
    if object.id == -1:
        return false
    if List.lookup(received_data.objects, "id", object.id):
        return true
    else:
        return false

func create_object(entry):
    return true

func confirm_created_objects(received_data):
    for entry in received_data.objects:
        if not List.lookup(objects, "id", entry.id):
            for i in range(awaiting_create_confirmation.size()):
                var awaiting_creation = awaiting_create_confirmation[i]
                var type = types[entry.type]
                if awaiting_creation.object is type:
                    awaiting_creation.object.id = entry.id
                    awaiting_create_confirmation.remove(i)
                    break

func confirm_deleted_objects():
    for i in range(awaiting_delete_confirmation.size()):
        var awaiting_deletion = awaiting_delete_confirmation[i]
        awaiting_deletion.object.queue_free()
        awaiting_delete_confirmation.remove(i)

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
            var on_deletion_queue = lookup(deletion_queue, "id", entry.id)
#            if on_deletion_queue && dictionary.tick > on_deletion_queue.tick:
#                on_deletion_queue.object.recreate()
#                on_deletion_queue.object.from_dictionary(entry)
#                objects.append(on_deletion_queue.object)
#                deletion_queue.erase(on_deletion_queue)
#            elif ...
            if not object && not on_deletion_queue:
                create_object(entry)

func remove_deleted_objects(dictionary):
    for i in range(objects.size() - 1, -1, -1):
        var object = objects[i]
        if not lookup(dictionary.objects, "id", object.id):
            objects.remove(i)
            object.queue_free()
    
    for i in range(deletion_queue.size() - 1, -1, -1):
        var delete_item = deletion_queue[i]
        if not lookup(dictionary.objects, "id", delete_item.id):
            if delete_item.object:
                delete_item.object.queue_free()
            deletion_queue.remove(i)

func erase_object(object):
    var created_object = lookup(creation_queue, "object", object)
    var created_local_id = created_object.local_id if created_object else -1
    CSV.write_line("res://object.csv", ["p_erase",tick,object.id,created_local_id,object.position,object.rotation])
    deletion_queue.append({"tick": tick, "id": object.id, "local_id": created_local_id, "object": object})
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
    for unclaimed in creation_queue:
        if unclaimed.id == -1:
            var distance = (entry.create_position - unclaimed.create_position).length()
            if distance < closest.distance:
                closest = { "distance": distance, "unclaimed": unclaimed }
    
    if closest.unclaimed:
        closest.unclaimed.id = entry.id
        var deleted_object = lookup(deletion_queue, "local_id", closest.unclaimed.local_id)
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
    var local_id = 0 # TODO: Solve later
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
    creation_queue.append({"tick": tick, "id": -1, "local_id": local_id, "object": bullet, "create_position": bullet.global_position})
    CSV.write_line("res://object.csv", ["p_create",tick,bullet.id,local_id-1,bullet.position,bullet.rotation])
    debug_bullet_create(bullet)

func debug_bullet_create(bullet):
    bullet.connect("tree_exited", self, "debug_bullet_destroy", [bullet])
    CSV.write_line("res://bullet.csv", [tick, "client_create_bullet"])

func debug_bullet_destroy(_bullet):
    CSV.write_line("res://bullet.csv", [tick, "client_destroy_bullet"])

func queue_remove_from_tree(child):
    var remove_from_tree_queue # TODO: Delete later
    remove_from_tree_queue.append(child)
