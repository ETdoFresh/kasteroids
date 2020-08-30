class_name Gun
extends Node2D

signal bullet_created(bullet)

export var shoot_velocity = 800

var is_ready = true

onready var cooldown = $Cooldown

func _ready():
    cooldown.connect("timeout", self, "ready_gun")

func fire():
    if not is_ready: return
    is_ready = false
    cooldown.start()
    
    var bullet = Scene.BULLET.instance()
    bullet.global_position = global_position
    bullet.global_rotation = global_rotation
    bullet.linear_velocity = Vector2(0, -shoot_velocity).rotated(global_rotation)
    emit_signal("bullet_created", bullet)

func ready_gun():
    is_ready = true
