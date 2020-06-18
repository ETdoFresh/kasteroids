extends Node2D

func create(scene, position, rotation, rigidbody, velocity_magnitude):
    var instance = scene.instance()
    instance.start(position, rotation, rigidbody, velocity_magnitude)
    add_child(instance)
    instance.owner = self
