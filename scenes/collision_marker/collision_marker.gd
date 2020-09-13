extends Node2D

var normal = Vector2.ZERO
var position1 = Vector2.ZERO
var position2 = Vector2.ZERO
var is_other = false

func _ready():
    var timer = Timer.new()
    timer.wait_time = 1
    timer.autostart = true
    add_child(timer)
    yield(timer, "timeout")
    queue_free()

func _draw():
    draw_circle(Vector2.ZERO, 2 * scale.x, Color.red)
    
    if normal != Vector2.ZERO:
        if is_other:
            draw_line(Vector2.ZERO, normal * 20, Color.green, 2)
        else:
            draw_line(Vector2.ZERO, normal * 20, Color.blue, 2)
