class_name Asteroid
extends KinematicBody2D

onready var collision_shape_2d = $CollisionShape2D
onready var wrap = $Wrap
onready var collision_sound = $CollisionSound
onready var randomize_asteroid = $RandomizeAsteroid
onready var history = $History
onready var serializer = $Serializer
onready var physics = $Physics

var id = -1

func _ready():
    physics.connect("collided", self, "play_collision_sound")
    randomize_asteroid.randomize_asteroid(self)

func simulate(delta):
    physics.simulate(self, delta)
    wrap.wrap(self)

func play_collision_sound(_collision):
    collision_sound.play_sound()

func to_dictionary():
    return serializer.to_dictionary(self, "Asteroid")

func from_dictionary(dictionary):
    serializer.from_dictionary(self, dictionary)

func record(tick):
    history.record(tick, to_dictionary())

func rewind(tick):
    from_dictionary(history.rewind(tick, self))

func erase_history(tick):
    history.erase_history(tick)
