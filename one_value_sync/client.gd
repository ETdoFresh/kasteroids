extends "res://networking/tcp_client.gd"

var tick = 0
var t = 0
var speed = 0.0001
var start = false

onready var tick_label = $Tick/Value
onready var t_label = $T/Value

func _ready():
    var _1 = connect("on_open", self, "start_game")
    var _2 = connect("on_receive", self, "update_state")
    var _3 = connect("on_close", self, "stop_game")

func _physics_process(_delta):
    if not start:
        return
    tick += 1
    t += speed

func _process(_delta):
    tick_label.text = String(tick)
    t_label.text = "%5.4f" % t
    $CosineGodotImage.t = t

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
    t = float(message)
