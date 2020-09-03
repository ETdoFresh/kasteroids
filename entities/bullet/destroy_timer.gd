extends Node

export var destroy_time = 1.0

var timer = 0

onready var parent = get_parent()

func simulate(delta):
    timer += delta
    if timer >= destroy_time:
        destroy()
        return

func destroy():
    var bullet_particles = Scene.BULLET_PARTICLES.instance()
    var container = get_parent()
    var world = container.get_parent()
    world.add_child(bullet_particles)
    bullet_particles.position = parent.global_position
    bullet_particles.emitting = true
    parent.queue_free()
