extends "res://networking/tcp_server.gd"

var update_timer = 0.0
var speed = 0.0001
var tick = 0
var t = 0

onready var tick_label = $Tick/Value
onready var t_label = $T/Value
onready var update_rate_lineedit = $SendRate/Value

func _enter_tree():
    console_write_ln("Starting Server...")
    #connect("on_open", self, "")
    #connect("on_close", self, "")
    listen()
    console_write_ln("Awaiting new connection...")

func _physics_process(_delta):
    tick += 1
    t += speed

func _process(delta):    
    tick_label.text = String(tick)
    t_label.text = "%5.4f" % t
    $CosineGodotImage.t = t
    
    var update_rate = int(update_rate_lineedit.text)
    if update_rate == 0: return
    
    update_timer += delta
    if update_timer < 1.0 / update_rate: return
    update_timer -= 1.0 / update_rate
    print("Sending: ", t_label.text, " to ", clients.size(), " clients")
    for client in clients:
        $LatencySimulator.send(client, t_label.text)

func console_write_ln(value):
    print(value)
