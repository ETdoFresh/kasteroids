extends Node

export var position = Vector2.ZERO
export var rotation = 0
export var scale = Vector2.ONE

func update(new_position, new_rotation, new_scale):
    position = new_position
    rotation = new_rotation
    scale = new_scale

func serialize():
    return [position, rotation, scale]

func deserialize(queue:Array):
    position.x = float(queue.pop_front())
    position.y = float(queue.pop_front())
    rotation = float(queue.pop_front())
    scale.x = float(queue.pop_front())
    scale.y = float(queue.pop_front())
