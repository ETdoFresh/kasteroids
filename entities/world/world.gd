extends Node2D

func serialize(client_tick, offset):
    $Serializer.tick = $Tick.tick
    $Serializer.last_received_client_tick = client_tick
    $Serializer.offset = offset
    return $Serializer.serialize()

func _physics_process(delta):
    $Tick.precise_tick += delta * Settings.simulation_iterations_per_second
    $Tick.tick = int(round($Tick.precise_tick))
    $Tick.time += delta

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.input = input
    ship.position = Vector2(630, 360)
    ship.connect("gun_fired", self, "create_bullet")
    $Ships.add_child(ship)
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
    var relative_velocity = ship.linear_velocity
    bullet.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(gun_rotation)
    $Bullets.add_child(bullet)

func delete_player(input):
    for player in $Players.get_children():
        if player.input == input:
            player.ship.queue_free()
            player.queue_free()
        
    $PlayerMonitor.remove_player_input(input)
