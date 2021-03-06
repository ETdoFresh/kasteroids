class_name Bullet
extends KinematicBody2D

var id = -1
var world = null
var starting_velocity = Vector2.ZERO
var ship = null
var ship_id = -1
var create_position

onready var shoot_sound = $ShootSound
onready var history = $History
onready var collision_shape_2d = $CollisionShape2D
onready var serializer = $Serializer
onready var physics = $Physics
onready var destroy_timer = $DestroyTimer
onready var wrap = $Wrap

func _enter_tree():
    create_position = global_position

func _ready():
    physics.connect("collided", self, "destroy")
    physics.linear_velocity = starting_velocity
    shoot_sound.play()

func simulate(delta):
    physics.simulate(delta, self)
    wrap.wrap(self)
    destroy_timer.simulate(delta)

func destroy(_collision):
    destroy_timer.destroy()

func recreate():
    destroy_timer.recreate()

func to_dictionary():
    return serializer.to_dictionary(self, "Bullet")

func from_dictionary(dictionary):
    serializer.from_dictionary(self, dictionary)

func record(tick):
    history.record(tick, to_dictionary())

func rewind(tick):
    from_dictionary(history.rewind(tick))

func erase_history(tick):
    history.erase_history(tick)

func queue_delete():
    if world: world.deletion_queue.append(self)
    else: queue_free()
