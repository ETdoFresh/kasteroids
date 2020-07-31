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
onready var update_rate_lineedit = $SendRate/Value
onready var server_tick = $ServerTick

func _ready():
    var _1 = connect("on_open", self, "start_game")
    var _2 = connect("on_receive", self, "update_state")
    var _3 = connect("on_close", self, "stop_game")

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
    $HBoxContainer/CosineGodotImage.t = last_received_t
    $HBoxContainer/CosineGodotImage2.t = interpolated_t
    $HBoxContainer/CosineGodotImage3.t = predicted_t
    $HBoxContainer/CosineGodotImage4.t = t
    
    var update_rate = int(update_rate_lineedit.text)
    if update_rate == 0: return
    
    update_timer += delta
    if update_timer < 1.0 / update_rate: return
    update_timer -= 1.0 / update_rate
    var message = "%s,|" % [tick]
    $LatencySimulator.send(client, message)
    $ServerTick.record_client_send(tick)

func _input(event):
    if event is InputEventKey:
        if event.scancode == KEY_C:
            start_client()

func start_client():
    if start: return
    start = true
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
        var server_tick = int(items[0])
        var client_tick = int(items[1])
        var offset_time = float(items[2])
        $ServerTick.record_client_recieve(server_tick, client_tick, offset_time)
        last_received_server_tick = server_tick
        last_received_client_tick = client_tick
        last_received_t = float(items[3])
