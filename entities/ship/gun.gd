class_name Gun
extends Node2D

export var shoot_velocity = 800

var is_ready = true

onready var cooldown = $Cooldown

func _ready():
    cooldown.connect("timeout", self, "ready_gun")

func fire():
    if not is_ready: return
    is_ready = false
    cooldown.start()

func ready_gun():
    is_ready = true
