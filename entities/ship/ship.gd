class_name Ship
extends KinematicBody2D

signal bullet_created(bullet)

var id = -1
var input = InputData.new()

onready var gun = $Gun
onready var collision_shape_2d = $CollisionShape2D
onready var wrap = $Wrap
onready var collision_sound = $CollisionSound
onready var history = $History
onready var serializer = $Serializer
onready var physics = $Physics
onready var name_node = $Name
onready var name_label = $Name/Label
onready var thrusters = $Thrusters

func _ready():
    physics.connect("collided", self, "play_collision_sound")
    gun.connect("bullet_created", self, "create_bullet")

func _process(_delta):
    name_node.global_position = global_position
    if "username" in input:
        name_label.text = input.username

func simulate(delta):
    thrusters.simulate(delta, input, physics)
    physics.simulate(delta, self)
    wrap.wrap(self)
    gun.simulate(delta)
    if input.fire:
        gun.fire()
    name_node.global_rotation = 0

func create_bullet(bullet):
    bullet.ship = self
    bullet.ship_id = id
    bullet.add_collision_exception_with(self)
    var relative_velocity = physics.linear_velocity
    bullet.starting_velocity += relative_velocity
    emit_signal("bullet_created", bullet)

func play_collision_sound(_collision):
    collision_sound.play()

func to_dictionary():
    return serializer.to_dictionary(self, "Ship")

func from_dictionary(dictionary):
    serializer.from_dictionary(self, dictionary)

func record(tick):
    history.record(tick, to_dictionary())
    gun.record(tick)

func rewind(tick):
    from_dictionary(history.rewind(tick))
    gun.rewind(tick)

func erase_history(tick):
    history.erase_history(tick)
    gun.erase_history(tick)
