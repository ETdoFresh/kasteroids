extends Node

signal deserialized

var id = -1
var instance_name = "No Name"
var position = Vector2.ZERO
var rotation = 0
var scale = Vector2.ONE
var linear_velocity = Vector2.ZERO
var angular_velocity = 0

func serialize():
    var output = ""
    output += Data.serialize_int(id)
    output += Data.serialize_string(instance_name)
    output += Data.serialize_Vector2(position)
    output += Data.serialize_float(rotation)
    output += Data.serialize_Vector2(scale)
    output += Data.serialize_Vector2(linear_velocity)
    output += Data.serialize_float(angular_velocity)
    return output

func deserialize(queue : PoolStringQueue):
    id = Data.deserialize_int(queue)
    instance_name = Data.deserialize_string(queue)
    position = Data.deserialize_Vector2(queue)
    rotation = Data.deserialize_float(queue)
    scale = Data.deserialize_Vector2(queue)
    linear_velocity = Data.deserialize_Vector2(queue)
    angular_velocity = Data.deserialize_float(queue)
    emit_signal("deserialized")

func update(u_id, u_instance_name, u_position, u_rotation, u_scale, u_linear_velocity, u_angular_velocity):
    id = u_id
    instance_name = u_instance_name
    position = u_position
    rotation = u_rotation
    scale = u_scale
    linear_velocity = u_linear_velocity
    angular_velocity = u_angular_velocity
