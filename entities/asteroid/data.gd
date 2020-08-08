extends Node

var id = -1
var position = Vector2.ZERO
var rotation = 0
var scale = Vector2.ONE
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

func _enter_tree():
    id = get_instance_id()

func update(new_position, new_rotation, new_scale, new_linear_velocity, new_angular_velocity):
    position = new_position
    rotation = new_rotation
    scale = new_scale
    linear_velocity = new_linear_velocity
    angular_velocity = new_angular_velocity

func deserialize(queue:Array):
    position.x = float(queue.pop_front())
    position.y = float(queue.pop_front())
    rotation = float(queue.pop_front())
    scale.x = float(queue.pop_front())
    scale.y = float(queue.pop_front())
    linear_velocity.x = float(queue.pop_front())
    linear_velocity.y = float(queue.pop_front())
    angular_velocity = float(queue.pop_front())
