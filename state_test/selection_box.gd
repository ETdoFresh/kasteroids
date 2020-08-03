extends Sprite

var status = "none"
var drag_offset = Vector2()
var mouse_position = Vector2()
var linked

func _process(_delta):
    if status == "dragging":
        position = mouse_position + drag_offset
        if linked != null:
            linked.queue_position(position)
    else:
        if linked != null:
            position = linked.position
            rotation = linked.rotation
        elif linked == null:
            rotation = 0


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.is_pressed() and status != "dragging":
            var spriterect
            if is_centered():
                spriterect = Rect2(position.x - texture.get_size().x / 2, position.y - texture.get_size().y / 2, texture.get_size().x, texture.get_size().y)
            else:
                spriterect = Rect2(position.x, position.y, texture.get_size().x, texture.get_size().y)
            if spriterect.has_point(event.global_position):
                status = "clicked"
                drag_offset = position - event.global_position

    if event is InputEventMouseMotion:
        if status == "clicked":
            status = "dragging"

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and status == "dragging":
            if not event.is_pressed():
                status = "released"
                if linked != null:
                    linked.queue_position(position)

    if event is InputEventMouse:
        mouse_position = event.global_position
