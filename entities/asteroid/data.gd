extends Node

var position = Vector2.ZERO
var rotation = 0
var scale = Vector2.ONE

func update(new_position, new_rotation, new_scale):
    position = new_position
    rotation = new_rotation
    scale = new_scale
