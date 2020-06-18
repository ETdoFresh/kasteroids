extends Node2D

const ShipScene = preload("res://entities/ship/ship.tscn")

func create():
    var ship = ShipScene.instance()
    add_child(ship)
    ship.owner = self
    return ship
