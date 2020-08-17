class_name Wrap
extends Node

onready var screen_size = get_viewport().get_visible_rect().size 

func wrap(node_2d : Node2D):
    while node_2d.global_position.x < 0:
        node_2d.global_position.x += screen_size.x
    while node_2d.global_position.x > screen_size.x:
        node_2d.global_position.x -= screen_size.x
    while node_2d.global_position.y < 0:
        node_2d.global_position.y += screen_size.y
    while node_2d.global_position.y > screen_size.y:
        node_2d.global_position.y -= screen_size.y
