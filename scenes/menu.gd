extends Control

const local = preload("res://scenes/Main.tscn")
const network = preload("res://scenes/NetworkTest.tscn")

onready var root = get_tree().get_root()

func _on_Button1_pressed():
    queue_free()
    root.add_child(local.instance())

func _on_Button2_pressed():
    queue_free()
    root.add_child(network.instance())
