class_name Asteroid
extends KinematicRigidBody2D

onready var collision_shape_2d = $CollisionShape2D
onready var wrap = $Wrap
onready var collision_sound = $CollisionSound
onready var randomize_asteroid = $RandomizeAsteroid
onready var history = $History
onready var network = $Network
onready var serializer = $Serializer

var id setget set_id, get_id
func set_id(v): $Network.id = v
func get_id(): return $Network.id

func _ready():
    var _1 = connect("collided", self, "play_collision_sound")
    randomize_asteroid.randomize_asteroid(self)

func simulate(delta):
    .simulate(delta)
    wrap.wrap(self)

func to_dictionary():
    return serializer.to_dictionary(self)

func from_dictionary(dictionary):
    serializer.from_dictionary(self, dictionary)

func record(tick):
    history.record(tick, to_dictionary())

func rewind(tick):
    history.rewind(tick, self)

func erase_history(tick):
    history.erase_history(tick)

func play_collision_sound(collision):
    collision_sound.play_sound()
