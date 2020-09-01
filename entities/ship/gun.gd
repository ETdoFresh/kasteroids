class_name Gun
extends Node2D

signal bullet_created(bullet)

export var cooldown_time = 0.2
export var shoot_velocity = 800

var next_shoot_time = 0
var timer = 0
var history = {}

func simulate(delta):
    timer += delta

func fire():
    if timer < next_shoot_time:
        return
    
    next_shoot_time = timer + cooldown_time
    var bullet = Scene.BULLET.instance()
    bullet.global_position = global_position
    bullet.global_rotation = global_rotation
    bullet.linear_velocity = Vector2(0, -shoot_velocity).rotated(global_rotation)
    emit_signal("bullet_created", bullet)

func record(tick):
    history[tick] = {"timer": timer, "next_shoot_time": next_shoot_time}

func rewind(tick):
    if history.has(tick):
        timer = history[tick].timer
        next_shoot_time = history[tick].next_shoot_time

func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)
