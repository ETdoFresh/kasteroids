extends Control

export (Curve) var fadeCurve

var message_queue = []

func _ready():
    #warning-ignore:return_value_discarded
    $FadeTimer.connect("timeout", self, "start_next_fade")
    if $FadeTimer.is_stopped() && message_queue.size() > 0:
        $Label.text = message_queue.pop_front()
        $FadeTimer.start()

func start_next_fade():
    if message_queue.size() > 0:
        $Label.text = message_queue.pop_front()
        $FadeTimer.start()

func set_text(text):
    message_queue.append(text)
    if $FadeTimer.is_inside_tree():
        $Label.text = message_queue.pop_front()
        $FadeTimer.start()

func _process(_delta):
    modulate = Color(1, 1, 1, fadeCurve.interpolate_baked(1 - $FadeTimer.time_left / $FadeTimer.wait_time))
