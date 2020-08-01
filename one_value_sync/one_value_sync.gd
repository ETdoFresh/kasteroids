extends Control

func _input(event):
    if event is InputEventKey:
        if event.is_pressed():
            if event.scancode == KEY_P:
                get_tree().paused = not get_tree().paused
            if event.scancode == KEY_R:
                var _1 = get_tree().reload_current_scene()
            if event.scancode == KEY_N:
                get_tree().paused = false
                yield(get_tree(), "physics_frame")
                yield(get_tree(), "physics_frame")
                get_tree().paused = true

onready var server_tick_value = $HBoxContainer/Server/Tick/Value
onready var client_smooth_tick_value = $HBoxContainer/Client/SmoothTick/Value
onready var future_time_value = $HBoxContainer/Client/FutureTime/Value
func _process(_delta):
    var server_tick = float(server_tick_value.text)
    var client_tick = float(client_smooth_tick_value.text)
    future_time_value.text = "%5.4f" % [(client_tick - server_tick) / Engine.iterations_per_second]
