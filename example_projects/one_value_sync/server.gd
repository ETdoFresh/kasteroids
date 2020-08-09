extends "res://entities/tcp/tcp_server.gd"

var update_timer = 0.0
var speed = 0.01
var tick = 10000
var t = 0
var last_received = {}
var ticks_received = []
var tick_rate = 1.0 / Settings.simulation_iterations_per_second
var time = 0
var misses = 0

onready var time_label = $Time/Value
onready var tick_label = $Tick/Value
onready var t_label = $T/Value
onready var update_rate_lineedit = $SendRate/Value
onready var misses_value = $Misses/Value

func _enter_tree():
    console_write_ln("Starting Server...")
    var _1 = connect("on_open", self, "update_last_received", ["0,"])
    var _2 = connect("on_close", self, "delete_client")
    var _3 = connect("on_receive", self, "update_last_received")
    listen()
    console_write_ln("Awaiting new connection...")

func _physics_process(delta):
    tick += 1
    t += speed * delta

func _process(delta):
    time += delta
    time_label.text = "%5.4f" % time
    tick_label.text = "%d" % tick
    t_label.text = "%5.4f" % t
    misses_value.text = "%d" % misses
    $CosineGodotImage.t = t
    
    
    var update_rate = int(update_rate_lineedit.text)
    if update_rate == 0: return
    
    update_timer += delta
    if update_timer < 1.0 / update_rate: return
    update_timer -= 1.0 / update_rate
    for client in clients:
        var last_received_time = last_received[client][1]
        var offset = time - last_received_time
        var message = "%s,%s,%s,%s|" % [tick, last_received[client][0], offset, t_label.text]
        $LatencySimulator.send(client, message)
        if not ticks_received.has(tick):
            misses += 1
        for i in range(ticks_received.size() - 1, -1, -1):
            if ticks_received[i] <= tick:
                ticks_received.remove(i)

func console_write_ln(value):
    print(value)

func update_last_received(client, message):
    var messages = message.split("|", false)
    for msg in messages:
        $Message/Value.text = msg
        var items = msg.split(",")
        var client_tick = int(items[0])
        last_received[client] = [client_tick, time]
        ticks_received.append(client_tick)

func delete_client(client):
    last_received.erase(client)
