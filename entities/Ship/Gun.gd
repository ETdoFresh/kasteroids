extends Node2D

const bullet_scene = preload("res://entities/Bullet/Bullet.tscn")

export var can_shoot = true
export var shoot_velocity = 800

onready var root = get_tree().get_root()
onready var ship = get_parent()
onready var cooldown = get_parent().get_node("GunCooldown")

func _on_Ship_fire():
    if not can_shoot: 
        return
    
    var bullet = bullet_scene.instance()
    root.add_child(bullet)
    bullet.rotation = self.global_rotation
    bullet.position = self.global_position
    bullet.add_collision_exception_with(ship)
    bullet.start(ship.linear_velocity, shoot_velocity)
    can_shoot = false
    cooldown.start()

func _on_GunCooldown_timeout():
    can_shoot = true
