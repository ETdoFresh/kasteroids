extends Node

export var destroy_time = 1.0

var timer = 0

onready var bullet = get_parent()
onready var container = bullet.get_parent()
onready var world = container.get_parent()

func simulate(delta):
    timer += delta
    if timer >= destroy_time:
        destroy()
        return

func destroy():
    var bullet_particles = Scene.BULLET_PARTICLES.instance()
    world.add_child(bullet_particles)
    bullet_particles.position = bullet.global_position
    bullet_particles.emitting = true
    if world.has_meta("queue_remove_child"):
        world.queue_remove_from_tree(bullet)
    else:
        bullet.queue_free()
