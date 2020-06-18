extends Node2D

const AsteroidScene = preload("res://entities/asteroid/asteroid.tscn")

func create():
    var asteroid = AsteroidScene.instance()
    add_child(asteroid)
    asteroid.owner = self
