extends Node2D

const bullet_scene = preload("res://entities/Bullet/Bullet.tscn")

func _on_Ship_fire():
	var bullet = bullet_scene.instance()
	get_tree().get_root().add_child(bullet)
	bullet.rotation = self.global_rotation
	bullet.position = self.global_position
