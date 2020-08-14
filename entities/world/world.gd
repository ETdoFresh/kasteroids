extends Node2D

var type = "update"
var tick = 0
var client = {"tick": -1, "offset": -1, "ship_id": -1}
var objects = []

func _ready():
    var _1 = $Tick.connect("tick", self, "simulate")
    for group in [$Asteroids, $Bullets, $Ships]:
        for object in group.get_children():
            object.data.id = ID.reserve()
            objects.append(object)

func to_dictionary(client_tick, offset, ship_id):
    client.tick = client_tick
    client.offset = offset
    client.ship_id = ship_id
    return Data.instance_to_dictionary(self)

func simulate():
    pass
    #$Players.update_ship_inputs()
    #Physics.step(Settings.tick_rate)

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.position = Vector2(630, 360)
    ship.connect("gun_fired", self, "create_bullet")
    ship.connect("tree_exited", $Serializer, "remove_object", [ship])
    $Ships.add_child(ship)
    objects.append(ship)
    $Players.add_player(ship, input)
    $PlayerMonitor.add_player_input(input)

func create_bullet(gun_position, gun_rotation, ship, speed):
    var bullet = Scene.BULLET.instance()
    bullet.global_position = gun_position
    bullet.global_rotation = gun_rotation
    bullet.add_collision_exception_with(ship)
    bullet.connect("tree_exited", $Serializer, "remove_object", [bullet])
    var relative_velocity = ship.linear_velocity
    bullet.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(gun_rotation)
    $Bullets.add_child(bullet)
    objects.append(bullet)

func delete_player(input):
    for player in $Players.get_children():
        if player.input == input:
            player.ship.queue_free()
            player.queue_free()
        
    $PlayerMonitor.remove_player_input(input)

func remove_object(object):
    objects.erase(object)
