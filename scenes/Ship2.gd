extends Node

class_name Ship2

onready var state_machine = $State

func _enter_tree():
    Global.emit_signal("node_created", self)

func _exit_tree():
    Global.emit_signal("node_destroyed", self)

func _on_InitiatingTimer_timeout():
    state_machine.set_state_by_name("Ghost")

func _on_GhostTimer_timeout():
    state_machine.set_state_by_name("Normal")

func _on_NormalTimer_timeout():
    state_machine.set_state_by_name("Exploding")

func _on_ExplodingTimer_timeout():
    state_machine.set_state_by_name("Initiating")
