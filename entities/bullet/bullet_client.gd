extends Node2D

onready var data = $Data

func _ready():
    data.connect("deserialized", self, "update_self")

func update_self():
    position = data.position
    rotation = data.rotation
    scale = data.scale
