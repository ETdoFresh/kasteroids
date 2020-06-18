class_name Gun
extends Node2D

const bullet_scene = preload("res://entities/bullet/bullet.tscn")

export var shoot_velocity = 800

onready var cooldown = $Cooldown

func fire(creator, rigidbody):
    if not cooldown.is_stopped(): 
        return
    
    creator.emit_signal("create", bullet_scene, global_position, global_rotation, rigidbody, shoot_velocity)
    
    cooldown.start()
