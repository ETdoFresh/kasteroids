class_name ShortcutFunctions

static func receive_input(event):
    if Input.is_key_pressed(KEY_CONTROL):
        if event is InputEventKey:
            if event.is_pressed():
                if event.scancode == KEY_R:
                    Game.load_menu_scene()
