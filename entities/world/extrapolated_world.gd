extends Node2D

var input = InputData.new()
var last_tick_received = 0
var server_tick_sync
var objects = []
var received_data
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }

func simulate(_delta):
    if received_data:
        process_received_data()
    if server_tick_sync:
        var time = (server_tick_sync.smooth_tick - last_tick_received) * Settings.tick_rate
        for object in objects:
            if object.has_meta("extrapolated_position"):
                object.position = object.get_meta("extrapolated_position")
                object.position += object.get_meta("linear_velocity") * time
                object.rotation = object.get_meta("extrapolated_rotation")
                object.rotation += object.get_meta("angular_velocity") * time

func process_received_data():
    if received_data.tick < last_tick_received:
        return
    else:
        last_tick_received = received_data.tick
    
    create_new_objects(received_data)
    remove_deleted_objects(received_data)
    
    for object in objects:
        var entry = List.lookup(received_data.objects, "id", object.id)
        object.set_meta("extrapolated_position", entry.position)
        object.set_meta("extrapolated_rotation", entry.rotation)
        object.set_meta("linear_velocity", entry.linear_velocity)
        object.set_meta("angular_velocity", entry.angular_velocity)
        object.scale = entry.scale

func create_new_objects(dictionary):
    for entry in dictionary.objects:
        if entry:
            if not List.lookup(objects, "id", entry.id):
                create_object(entry)

func remove_deleted_objects(dictionary):
    for i in range(objects.size() - 1, -1, -1):
        var object = objects[i]
        if not List.lookup(dictionary.objects, "id", object.id):
            objects.remove(i)
            object.queue_free()

func create_object(entry):
    var type = entry.type
    var object = types[type].instance()
    objects.append(object)
    containers[type].add_child(object)
    object.from_dictionary(entry)
