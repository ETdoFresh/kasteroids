class_name Gun
extends Node2D

export var shoot_velocity = 800

onready var cooldown = $Cooldown

func fire(creator, rigidbody):
    if not cooldown.is_stopped(): 
        return
    
    creator.emit_signal("create", Scene.BULLET, global_position, global_rotation, rigidbody, shoot_velocity)
    
    cooldown.start()
