class_name ShortcutFunctions

static func receive_input(event, node: Node):
    if Input.is_key_pressed(KEY_CONTROL):
        if event is InputEventKey:
            if event.is_pressed():
                if event.scancode == KEY_R:
                    var _1 = node.get_tree().reload_current_scene()
