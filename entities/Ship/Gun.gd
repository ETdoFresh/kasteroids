extends Node2D

const bullet_scene = preload("res://entities/Bullet/Bullet.tscn")

export var shoot_velocity = 800

onready var root = get_tree().get_root()
onready var ship = get_parent()

func _on_Ship_fire():
    var bullet = bullet_scene.instance()
    root.add_child(bullet)
    bullet.rotation = self.global_rotation
    bullet.position = self.global_position
    bullet.start(ship.linear_velocity, shoot_velocity)
