extends Control

signal up_pressed
signal up_released
signal down_pressed
signal down_released
signal left_pressed
signal left_released
signal right_pressed
signal right_released
signal fire_pressed
signal fire_released

func _on_Up_button_down():
    emit_signal("up_pressed")

func _on_Up_button_up():
    emit_signal("up_released")

func _on_Left_button_down():
    emit_signal("left_pressed")

func _on_Left_button_up():
    emit_signal("left_released")

func _on_Down_button_down():
    emit_signal("down_pressed")

func _on_Down_button_up():
    emit_signal("down_released")

func _on_Right_button_down():
    emit_signal("right_pressed")

func _on_Right_button_up():
    emit_signal("right_released")

func _on_Fire_button_down():
    emit_signal("fire_pressed")

func _on_Fire_button_up():
    emit_signal("fire_released")
