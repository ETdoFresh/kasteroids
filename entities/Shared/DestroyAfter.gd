extends Node

class_name DestroyAfter

export var time = 1

var parent
var timer

func _ready():
	parent = get_parent()
	timer = Timer.new()
	timer.set_wait_time(time)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	parent.queue_free()
