extends Node

signal deserialized

export var type = "Not Specified"

var id = -1
var instance_name = "No Name"
var position = Vector2.ZERO
var rotation = 0
var scale = Vector2.ONE
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

func to_dictionary():
    return Data.instance_to_dictionary(self)

func from_dictionary(dictionary):
    Data.dictionary_to_instance(dictionary, self)
    
func to_csv():
    return Data.list_to_csv([
        id, 
        type, 
        instance_name,
        position.x, position.y, 
        rotation,
        scale.x, scale.y, 
        linear_velocity.x, linear_velocity.y,
        angular_velocity])

func from_csv(csv):
    var items = Data.csv_to_list(csv)
    id = items[0]
    type = items[1]
    instance_name = items[2]
    position = Vector2(float(items[3]), float(items[4]))
    rotation = float(items[5])
    scale = Vector2(float(items[6]), float(items[7]))
    linear_velocity = Vector2(float(items[8]), float(items[9]))
    angular_velocity = float(items[10])

func apply(entity):
    for variable_name in ["id", "type", "instance_name", "position", "rotation", "scale", "linear_velocity", "angular_velocity"]:
        if variable_name in entity:
            entity[variable_name] = self[variable_name]
