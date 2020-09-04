extends Node2D

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

func process_received_data():
    create_new_objects(received_data)
    remove_deleted_objects(received_data)
    update_objects(received_data)
    received_data = null

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

func update_objects(dictionary):
    for object in objects:
        var entry = List.lookup(dictionary.objects, "id", object.id)
        object.from_dictionary(entry)

func create_object(entry):
    var type = entry.type
    var object = types[type].instance()
    objects.append(object)
    containers[type].add_child(object)
    object.from_dictionary(entry)
