extends Node2D

var id = -1
var max_linear_velocity = 500 * 1.1
var max_angular_velocity = 500 * 1.1

func from_dictionary(dictionary):
    for key in dictionary:
        if key in self:
            self[key] = dictionary[key]
