extends Node2D

var objects = []

onready var collision_manager = $CollisionManager
onready var world_serializer = $WorldSerializer
onready var tick = $Tick

func _ready():
    var _1 = tick.connect("tick", self, "simulate")
    for group in [$Asteroids, $Bullets, $Ships]:
        for object in group.get_children():
            object.id = ID.reserve()
            if "physics" in object: object.physics.collision_manager = collision_manager
            objects.append(object)

func to_dictionary(client_tick, offset, ship_id):
    return world_serializer.to_dictionary(self, {"tick": client_tick, "offset": offset, "ship_id": ship_id}, "Update")

func simulate():
    $Players.update_ship_inputs(tick.tick)
    for object in objects:
        object.simulate(Settings.tick_rate)
    $CollisionManager.resolve()

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.position = Vector2(630, 360)
    $Ships.add_child(ship)
    add_object(ship)
    $Players.add_player(ship, input)
    $PlayerMonitor.add_player_input(input)
    ship.connect("bullet_created", self, "create_bullet")
    return ship

func create_bullet(bullet):
    $Bullets.add_child(bullet)
    bullet.physics.collision_manager = collision_manager
    add_object(bullet)

func delete_player(input):
    var player = $Players.lookup("input", input)
    player.ship.queue_free()
    $Players.remove_player_by_input(input)
    $PlayerMonitor.remove_player_input(input)

func add_object(object):
    object.id = ID.reserve()
    objects.append(object)
    object.record(tick.tick)
    object.connect("tree_exited", self, "remove_object", [object])

func remove_object(object):
    ID.release(object.id)
    objects.erase(object)
