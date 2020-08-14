extends Node2D

var id = -1

func from_dictionary(dictionary):
    for key in dictionary:
        if key in self:
            self[key] = dictionary[key]
