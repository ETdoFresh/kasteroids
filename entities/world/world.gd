extends Node2D

var objects = []
var creation_queue = []
var deletion_queue = []

onready var asteroids = $Asteroids
onready var bullets = $Bullets
onready var ships = $Ships
onready var collision_manager = $CollisionManager
onready var world_serializer = $WorldSerializer
onready var tick = $Tick
onready var players = $Players
onready var player_monitor = $PlayerMonitor

func _ready():
    var _1 = tick.connect("tick", self, "simulate")
    for container in [asteroids, bullets, ships]:
        for object in container.get_children():
            add_object(object)

func to_dictionary(client_data):
    return world_serializer.to_dictionary(self, client_data, "Update")

func simulate():
    players.update_ship_inputs(tick.tick)
    simulate_objects()
    delete_objects()
    create_objects()

func simulate_objects():
    for object in objects:
        object.simulate(Settings.tick_rate)
    collision_manager.resolve()

func delete_objects():
    for i in range(deletion_queue.size() - 1, -1, -1):
        deletion_queue[i].queue_free()
        deletion_queue.remove(i)

func create_objects():
    for i in range(creation_queue.size() - 1, -1, -1):
        var object = creation_queue[i].object
        var container = creation_queue[i].container
        container.add_child(object)
        add_object(object)
        creation_queue.remove(i)

func create_player(input):
    var ship = Scene.SHIP.instance()
    ship.position = Vector2(630, 360)
    input.username = Data.get_username()
    creation_queue.append({"object": ship, "container": ships})
    players.add_player(ship, input)
    player_monitor.add_player_input(input)
    ship.connect("bullet_created", self, "create_bullet")
    return ship

func create_bullet(bullet):
    creation_queue.append({"object": bullet, "container": bullets})

func delete_player(input):
    var player = players.lookup("input", input)
    deletion_queue.append(player.ship)
    players.remove_player_by_input(input)
    player_monitor.remove_player_input(input)

func add_object(object):
    object.id = ID.reserve()
    objects.append(object)
    object.record(tick.tick)
    object.connect("tree_exited", self, "remove_object", [object])
    object.physics.collision_manager = collision_manager

func remove_object(object):
    ID.release(object.id)
    objects.erase(object)
