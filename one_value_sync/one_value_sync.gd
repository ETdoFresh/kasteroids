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
