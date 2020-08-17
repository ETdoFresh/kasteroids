extends Node2D

var entity_list = []
var types = {
    "Ship": Scene.SHIP_CLIENT,
    "Asteroid": Scene.ASTEROID_CLIENT,
    "Bullet": Scene.BULLET_CLIENT }

onready var containers = { 
    "Ship": $Ships, "Asteroid": $Asteroids, "Bullet": $Bullets }
onready var predicted_world = get_parent().get_node("PredictedWorld")

func _physics_process(delta):
    create_new_entities(predicted_world.entity_list)
    remove_deleted_entities(predicted_world.entity_list)
    update_entities(delta)

func create_new_entities(other_world_entity_list):
    for other_world_entity in other_world_entity_list:
        var entry = other_world_entity.to_dictionary()
        var entity = get_entity_by_id(entry.id)
        if not entity:
            create_entity(entry)

func remove_deleted_entities(other_world_entity_list):
    for i in range(entity_list.size() - 1, -1, -1):
        var entity = entity_list[i]
        if not get_dictionary_entry_by_id(other_world_entity_list, entity.id):
            entity_list.remove(i)
            entity.queue_free()

func update_entities(delta_time):
    for entity in entity_list:
        var other_world_entity = get_dictionary_entry_by_id(predicted_world.entity_list, entity.id)
        var other_world_entry = other_world_entity.to_dictionary()
        var delta_position = other_world_entry.position - entity.position
        var scaled_max_linear_velocity = entity.max_linear_velocity * delta_time
        if delta_position.length() > 250:
            pass
        elif delta_position.length() > scaled_max_linear_velocity:
            delta_position = delta_position.normalized() * scaled_max_linear_velocity
        entity.position += delta_position
        entity.rotation = other_world_entry.rotation
        entity.scale = other_world_entry.scale

func get_entity_by_id(id):
    for entity in entity_list:
        if entity.id == id:
            return entity
    return null

func get_dictionary_entry_by_id(other_world_entity_list, id):
    for other_world_entity in other_world_entity_list:
        if other_world_entity.id == id:
            return other_world_entity
    return null

func create_entity(entry):
    var type = entry.type
    var entity = types[type].instance()
    entity_list.append(entity)
    entity.from_dictionary(entry)
    containers[type].add_child(entity)
