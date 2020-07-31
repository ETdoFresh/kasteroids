extends "res://networking/tcp_server.gd"

var update_timer = 0.0
var speed = 0.0001
var tick = 10000
var t = 0
var last_received = {}

onready var tick_label = $Tick/Value
onready var t_label = $T/Value
onready var update_rate_lineedit = $SendRate/Value

func _enter_tree():
    console_write_ln("Starting Server...")
    var _1 = connect("on_open", self, "update_last_received", ["0,"])
    var _2 = connect("on_close", self, "delete_client")
    var _3 = connect("on_receive", self, "update_last_received")
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
    for client in clients:
        var message = "%s,%s,%s" % [tick, last_received[client], t_label.text]
        $LatencySimulator.send(client, message)

func console_write_ln(value):
    print(value)

func update_last_received(client, message):
    $Message/Value.text = message
    var items = message.split(",")
    last_received[client] = int(items[0])

func delete_client(client):
    last_received.erase(client)
