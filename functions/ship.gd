extends Node

var simulate_ships = funcref(self, "_simulate_ships")
var simulate_ship_fire = funcref(self, "_simulate_ship_fire")
var simulate = funcref(self, "_simulate")
var is_ship = funcref(self, "_is_ship")
var is_ready_to_fire = funcref(self, "_is_ready_to_fire")
var fire = funcref(self, "_fire")

func _simulate_ships(_key, objects, delta):
    var result = objects
    result = filter(result, is_ship)
    result = map(result, simulate, delta)
    result = merge(objects, result)
    return result

func _simulate_ship_fire(_key, objects):
    var result = objects
    result = filter(result, is_ship)
    result = map(result, fire)
    result = merge(objects, result)
    return result

static func _simulate(_key: int, ship: Dictionary, delta: float) -> Dictionary:
    ship = _apply_input(ship, delta)
    ship = _limit_speed(ship)
    ship = _cooldown(ship, delta)
    return ship

static func _is_ship(_key: int, object : Dictionary) -> bool:
    return "type" in object and object.type == "Ship"

static func _is_ready_to_fire(ship: Dictionary) -> bool:
    return ship.cooldown_timer <= 0

static func _apply_input(ship : Dictionary, delta: float) -> Dictionary:
    ship = ship.duplicate()
    var thrust = Vector2(0, ship.input.vertical * ship.speed)
    var linear_acceleration = thrust.rotated(ship.rotation)
    ship.linear_velocity += linear_acceleration * delta
    
    var rotation_dir = ship.input.horizontal
    ship.angular_velocity = rotation_dir * ship.spin * delta
    return ship

static func _limit_speed(ship : Dictionary) -> Dictionary:
    ship = ship.duplicate()
    if ship.linear_velocity.length() > ship.speed:
        ship.linear_velocity = ship.linear_velocity.normalized() * ship.speed
    return ship

static func _cooldown(ship: Dictionary, delta: float) -> Dictionary:
    if ship.cooldown_timer > 0:
        ship = ship.duplicate()
        ship.cooldown_timer -= delta
    return ship

static func _fire(_key, ship: Dictionary) -> Dictionary:
    if _is_ready_to_fire(ship):
        if ship.input.fire:
            ship = ship.duplicate()
            ship.cooldown_timer = ship.cooldown
    return ship

static func filter(dict, func_ref): return DictionaryFunctions.filter(dict, func_ref)
static func map(dict, func_ref, arg = null): return DictionaryFunctions.map(dict, func_ref, arg)
static func merge(dest, src): return DictionaryFunctions.merge(dest, src)
