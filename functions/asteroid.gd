extends Node

var is_asteroid: FuncRef = funcref(self, "_is_asteroid")
var randomize_asteroids = funcref(self, "_randomize_asteroids")
var randomize_angular_velocity = funcref(self, "_randomize_angular_velocity")
var randomize_linear_velocity = funcref(self, "_randomize_linear_velocity")
var randomize_scale = funcref(self, "_randomize_scale")

static func _is_asteroid(_id: int, object: Dictionary) -> bool:
    return "type" in object and object.type == "Asteroid"

func _randomize_asteroids(_key, objects):
    var result = objects
    result = filter(result, is_asteroid)
    result = map(result, randomize_angular_velocity)
    result = map(result, randomize_linear_velocity)
    result = map(result, randomize_scale)
    result = merge(objects, result)
    return result

static func _randomize_angular_velocity(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_angular_velocity: return asteroid
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_angular_velocity
    var max_vel = asteroid.max_angular_velocity
    asteroid.angular_velocity = Random.randf_range(min_vel, max_vel)
    return asteroid

static func _randomize_linear_velocity(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_linear_velocity: return asteroid
    asteroid = asteroid.duplicate()
    var min_vel = asteroid.min_linear_velocity
    var max_vel = asteroid.max_linear_velocity
    asteroid.linear_velocity = Random.on_unit_circle()
    asteroid.linear_velocity *= Random.randf_range(min_vel, max_vel)
    return asteroid

static func _randomize_scale(_id: int, asteroid: Dictionary) -> Dictionary:
    if not asteroid.randomize_scale: return asteroid
    asteroid = asteroid.duplicate()
    var min_scl = asteroid.min_scale
    var max_scl = asteroid.max_scale
    asteroid.scale *= Random.randf_range(min_scl, max_scl)
    return asteroid

static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
static func map(dict, func_ref): return DictionaryFunctions.map(dict, func_ref)
static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)
