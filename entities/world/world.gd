extends Node2D

func _ready():
    for group in [$Asteroids, $Bullets, $Ships]:
        for child in group.get_children():
            child.data.id = ID.reserve()
            $Serializer.add_entity(child)

func serialize(client_tick, offset, ship):
    $Serializer.dictionary.tick = $Tick.tick
    $Serializer.dictionary.client_tick = client_tick
    $Serializer.dictionary.offset = offset
    $Serializer.dictionary.ship_id = ship.data.id
    return $Serializer.serialize()

func _physics_process(delta):
    $Tick.precise_tick += delta * Settings.ticks_per_second
    $Tick.tick = int(round($Tick.precise_tick))
    $Tick.time += delta

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.input = input
    ship.position = Vector2(630, 360)
    ship.connect("gun_fired", self, "create_bullet")
    ship.connect("tree_exited", $Serializer, "remove_entity", [ship])
    $Ships.add_child(ship)
    $Serializer.add_entity(ship)
    var player = Scene.PLAYER.instance()
    player.ship = ship
    player.input = input
    $Players.add_child(player)
    $PlayerMonitor.add_player_input(input)

func create_bullet(gun_position, gun_rotation, ship, speed):
    var bullet = Scene.BULLET.instance()
    bullet.global_position = gun_position
    bullet.global_rotation = gun_rotation
    bullet.add_collision_exception_with(ship)
    bullet.connect("tree_exited", $Serializer, "remove_entity", [bullet])
    var relative_velocity = ship.linear_velocity
    bullet.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(gun_rotation)
    $Bullets.add_child(bullet)
    $Serializer.add_entity(bullet)

func delete_player(input):
    for player in $Players.get_children():
        if player.input == input:
            player.ship.queue_free()
            player.queue_free()
        
    $PlayerMonitor.remove_player_input(input)
