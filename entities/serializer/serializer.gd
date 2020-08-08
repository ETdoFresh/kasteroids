class_name Serializer
extends Node

var tick
var last_received_client_tick
var offset

onready var world = get_parent()
onready var asteroids = world.get_node("Asteroids")
onready var bullets = world.get_node("Bullets")
onready var ships = world.get_node("Ships")

func serialize():
    var serialized = "%d,%d,%d," % [tick, last_received_client_tick, offset]
    for group in [ships, asteroids, bullets]:
        serialized += String(group.get_child_count()) + ","
        for node in group.get_children():
            if node.has_node("Data"):
                var data = node.get_node("Data")
                serialized += serialize_int(data.id)
                serialized += serialize_Vector2(data.position)
                serialized += serialize_float(data.rotation)
                serialized += serialize_Vector2(data.scale)
                serialized += serialize_Vector2(data.linear_velocity)
                serialized += serialize_float(data.angular_velocity)
    return serialized

func serialize_Vector2(v):
    return "%f,%f," % [v.x, v.y]

func serialize_float(v):
    return "%f," % v

func serialize_int(v):
    return "%d," % v
