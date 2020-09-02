extends Node2D

var type = "update"
var tick = 0
var client = {"tick": -1, "offset": -1, "ship_id": -1}
var objects = []

func _ready():
    var _1 = $Tick.connect("tick", self, "simulate")
    for group in [$Asteroids, $Bullets, $Ships]:
        for object in group.get_children():
            object.id = ID.reserve()
            if "physics" in object: object.physics.collision_manager = $CollisionManager
            objects.append(object)
    CSV.write_line("res://server_world.csv",
     ["Action","Tick","Horizontal","Vertical","Fire","ID1","Name1","Position1X","Position1Y","Rotation1","ID2","Name2","Position2X","Position2Y","Rotation2",
      "ID3","Name3","Position3X","Position3Y","Rotation3","ID4","Name4","Position4X","Position4Y","Rotation4","ID5","Name5","Position5X","Position5Y","Rotation5"])

func to_log(action, log_tick, log_input, log_objects):
    if not action in ["Simulate"]:
        return
    
    var values = []
    values.append(action)
    values.append(log_tick)
    values.append(log_input.horizontal)
    values.append(log_input.vertical)
    values.append(log_input.fire)
    for object in log_objects:
        if object:
            values.append(object.id)
            values.append(object.name if "name" in object else object.type)
            values.append(object.position)
            values.append(object.rotation)
        else:
            values.append("Null")
            values.append("N/A")
            values.append("N/A")
    CSV.write_line("res://server_world.csv", values)

func to_dictionary(client_tick, offset, ship_id):
    client.tick = client_tick
    client.offset = offset
    client.ship_id = ship_id
    return Data.instance_to_dictionary(self)

func simulate():
    tick = $Tick.tick
    $Players.update_ship_inputs(tick)
    for object in objects:
        if object:
            object.simulate(Settings.tick_rate)
    $CollisionManager.resolve()
    
    var input = $Players.players[0].input if $Players.players.size() > 0 else InputData.new()
    to_log("Simulate", tick, input, objects)

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.position = Vector2(630, 360)
    $Ships.add_child(ship)
    add_object(ship)
    $Players.add_player(ship, input)
    $PlayerMonitor.add_player_input(input)
    ship.connect("bullet_created", self, "add_object")
    ship.connect("bullet_created", $Bullets, "add_child")
    ship.connect("bullet_created", self, "debug_bullet_create")
    return ship

func debug_bullet_create(bullet):
    bullet.connect("tree_exited", self, "debug_bullet_destroy")
    CSV.write_line("res://bullet.csv", [tick, "server_create_bullet"])

func debug_bullet_destroy():
    CSV.write_line("res://bullet.csv", [tick, "server_destroy_bullet"])

func delete_player(input):
    var player = $Players.lookup("input", input)
    player.ship.queue_free()
    $Players.remove_player_by_input(input)
    $PlayerMonitor.remove_player_input(input)

func add_object(object):
    object.id = ID.reserve()
    objects.append(object)
    object.record(tick)
    object.connect("tree_exited", self, "remove_object", [object])
    CSV.write_line("res://object.csv", ["create",tick,object.id,-1,object.position,object.rotation])

func remove_object(object):
    CSV.write_line("res://object.csv", ["remove",tick,object.id,-1,object.position,object.rotation])
    ID.release(object.id)
    objects.erase(object)
