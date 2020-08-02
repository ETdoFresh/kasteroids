extends "res://networking/tcp_client.gd"

var tick = 0
var t = 0
var last_received_server_tick = 0
var last_received_client_tick = 0
var last_received_t = 0
var interpolated_t = 0
var predicted_t = 0
var speed = 0.01
var start = false
var update_timer = 0
var tick_rate = 1.0 / Engine.iterations_per_second
var time = 0

onready var time_label = $Time/Value
onready var tick_label = $Tick/Value
onready var t_label = $T/Value
onready var rtt_value = $RTT/Value
onready var predicted_tick_value = $PredictedTick/Value
onready var future_tick_value = $FutureTick/Value
onready var update_rate_lineedit = $SendRate/Value
onready var server_tick = $ServerTick
onready var smooth_tick_value = $SmoothTick/Value
onready var predicted_t_value = $PredictedT/Value
onready var predict_misses_value = $PredictMisses/Value

func _ready():
    var _1 = connect("on_open", self, "start_game")
    var _2 = connect("on_receive", self, "update_state")
    var _3 = connect("on_close", self, "stop_game")
    var _4 = server_tick.connect("tick", self, "send_tick")

func _physics_process(delta):
    if not start:
        return
    tick += 1
    t += speed * delta

func _process(delta):
    if start: time += delta
    time_label.text = "%5.4f" % time
    tick_label.text = "%d" % tick
    t_label.text = "%5.4f" % t
    rtt_value.text = "%5.4f" % server_tick.rtt
    predicted_tick_value.text = "%5.4f" % server_tick.prediction
    future_tick_value.text = "%5.4f" % server_tick.future_tick
    smooth_tick_value.text = "%d" % server_tick.smooth_tick
    predicted_t_value.text = "%5.4f" % predicted_t
    predict_misses_value.text = "%d" % $Prediction.misses
    interpolate()
    predict()
    $HBoxContainer/CosineGodotImage.t = last_received_t
    $HBoxContainer/CosineGodotImage2.t = interpolated_t
    $HBoxContainer/CosineGodotImage3.t = predicted_t
    $HBoxContainer/CosineGodotImage4.t = t

func send_tick():
    var message = create_repeat_history_input_message()
    $LatencySimulator.send(client, message)
    $ServerTick.record_client_send(server_tick.smooth_tick)

func _input(event):
    if event is InputEventKey:
        if event.scancode == KEY_C:
            start_client()

func create_repeat_history_input_message():
    var number_of_repeats = 6
    var message = ""
    for i in range(number_of_repeats - 1, -1, -1):
        message += "%s,|" % [server_tick.smooth_tick - i]
    return message

func start_client():
    if start: return
    start = true
    var _1 = server_tick.connect("tick", $Prediction, "simulate")
    open()

func start_game():
    tick = 0
    t = 0
    speed = 0.01

func stop_game():
    tick = 0
    t = 0
    speed = 0
    start = false

func update_state(message):
    var messages = message.split("|", false)
    for msg in messages:
        $Message/Value.text = msg
        var items = msg.split(",")
        # warning-ignore:shadowed_variable
        var server_tick = int(items[0])
        var client_tick = int(items[1])
        var offset_time = float(items[2])
        var received_t = float(items[3])
        $ServerTick.record_client_recieve(server_tick, client_tick, offset_time)
        $Interpolation.add(server_tick, received_t)
        $Prediction.recieve_and_correct_past(server_tick, received_t)
        last_received_server_tick = server_tick
        last_received_client_tick = client_tick
        last_received_t = received_t

func interpolate():
    var smooth_prediction = server_tick.smooth_tick - server_tick.rtt / tick_rate
    var rate = server_tick.rtt * 1.5
    rate = max(0.1, rate)
    # TODO: Think of some way to keep the rate more consistent than RTT
    var new_interpolated_t = $Interpolation.interpolate(smooth_prediction, rate)
    if new_interpolated_t != null:
        interpolated_t = new_interpolated_t

func predict():
    predicted_t = $Prediction.t
