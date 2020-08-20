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
            objects.append(object)
    CSV.write_line("res://server_world.csv",
     ["Action","Tick","Horizontal","Vertical","Fire","Name1","Position1X","Position1Y","Rotation1","Name2","Position2X","Position2Y","Rotation2",
      "Name3","Position3X","Position3Y","Rotation3","Name4","Position4X","Position4Y","Rotation4","Name5","Position5X","Position5Y","Rotation5"])

func to_log(action, log_tick, log_input, log_objects):
    var values = []
    values.append(action)
    values.append(log_tick)
    values.append(log_input.horizontal)
    values.append(log_input.vertical)
    values.append(log_input.fire)
    for object in log_objects:
        values.append(object.name if "name" in object else object.type)
        values.append(object.position)
        values.append(object.rotation)
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
        object.simulate(Settings.tick_rate)
    
    var input = $Players.players[0].input if $Players.players.size() > 0 else InputData.new()
    to_log("Simulate", tick, input, objects)

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.id = ID.reserve()
    ship.position = Vector2(630, 360)
    ship.connect("gun_fired", self, "create_bullet")
    ship.connect("tree_exited", self, "remove_object", [ship])
    $Ships.add_child(ship)
    objects.append(ship)
    $Players.add_player(ship, input)
    $PlayerMonitor.add_player_input(input)
    return ship

func create_bullet(gun_position, gun_rotation, ship, speed):
    var bullet = Scene.BULLET.instance()
    bullet.id = ID.reserve()
    bullet.global_position = gun_position
    bullet.global_rotation = gun_rotation
    bullet.add_collision_exception_with(ship)
    bullet.connect("tree_exited", self, "remove_object", [bullet])
    var relative_velocity = ship.linear_velocity
    bullet.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(gun_rotation)
    $Bullets.add_child(bullet)
    objects.append(bullet)

func delete_player(input):
    var player = $Players.lookup("input", input)
    player.ship.queue_free()
    $Players.remove_player_by_input(input)
    $PlayerMonitor.remove_player_input(input)

func remove_object(object):
    ID.release(object.id)
    objects.erase(object)
