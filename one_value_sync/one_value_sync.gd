extends Control

func _input(event):
    if event is InputEventKey:
        if event.scancode == KEY_P:
            if event.is_pressed():
                get_tree().paused = not get_tree().paused
