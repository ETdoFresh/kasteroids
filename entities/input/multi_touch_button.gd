extends Button

signal touch_button_down
signal touch_button_up
signal touch_button_down_event(event)
signal touch_button_up_event(event)

var down_index = -1

func _gui_input(event):
    if event is InputEventScreenTouch:
        if event.is_pressed():
            down_index = event.index
            emit_signal("touch_button_down")
            emit_signal("touch_button_down_event", event)
        else:
            down_index = -1
            emit_signal("touch_button_up")
            emit_signal("touch_button_up_event", event)
    if event is InputEventMouseButton:
        if event.is_pressed():
            emit_signal("touch_button_down")
            emit_signal("touch_button_down_event", event)
        else:
            down_index = -1
            emit_signal("touch_button_up")
            emit_signal("touch_button_up_event", event)

func _input(event):
    if event is InputEventScreenTouch:
        if not event.is_pressed():
            if down_index == event.index:
                down_index = -1
                emit_signal("touch_button_up")
                emit_signal("touch_button_up_event", event)
