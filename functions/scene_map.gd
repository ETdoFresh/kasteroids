class_name SceneMap

static func get_map():
    return {
        "Asteroid": preload("res://scenes/asteroid/asteroid.tscn"),
        "Bullet": preload("res://scenes/bullet/bullet.tscn"),
    }

static func get_scene(type_name: String) -> PackedScene:
    if get_map().has(type_name):
        return get_map()[type_name]
    else:
        return null
