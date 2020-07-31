extends "res://networking/tcp_client.gd"

var tick = 0
var t = 0
var last_received_server_tick = 0
var last_received_client_tick = 0
var last_received_t = 0
var interpolated_t = 0
var predicted_t = 0
var speed = 0.0001
var start = false
var update_timer = 0

onready var tick_label = $Tick/Value
onready var t_label = $T/Value
onready var update_rate_lineedit = $SendRate/Value

func _ready():
    var _1 = connect("on_open", self, "start_game")
    var _2 = connect("on_receive", self, "update_state")
    var _3 = connect("on_close", self, "stop_game")

func _physics_process(_delta):
    if not start:
        return
    tick += 1
    t += speed

func _process(delta):
    tick_label.text = String(tick)
    t_label.text = "%5.4f" % t
    $HBoxContainer/CosineGodotImage.t = last_received_t
    $HBoxContainer/CosineGodotImage2.t = interpolated_t
    $HBoxContainer/CosineGodotImage3.t = predicted_t
    $HBoxContainer/CosineGodotImage4.t = t
    
    var update_rate = int(update_rate_lineedit.text)
    if update_rate == 0: return
    
    update_timer += delta
    if update_timer < 1.0 / update_rate: return
    update_timer -= 1.0 / update_rate
    var message = "%s," % [tick]
    $LatencySimulator.send(client, message)

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
    speed = 0.0001

func stop_game():
    tick = 0
    t = 0
    speed = 0
    start = false

func update_state(message):
    $Message/Value.text = message
    var items = message.split(",")
    last_received_server_tick = int(items[0])
    last_received_client_tick = int(items[1])
    last_received_t = float(items[2])
