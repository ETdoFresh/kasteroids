extends Node2D

var id = -1
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

func from_dictionary(dictionary):
    for key in dictionary:
        if key in self:
            self[key] = dictionary[key]
