extends Node

var sent = []
var received = []

func get_sent_from_tick(tick):
    for item in sent:
        if item[0] == tick:
            return item
    return null

func clear_sent_before_tick(tick):
    for i in range(sent.size() - 1, -1, -1):
        if sent[i][0] < tick:
            sent.remove(i)

func get_received_from_tick(tick):
    for item in received:
        if item[0] == tick:
            return item
    return null

func clear_received_before_tick(tick):
    for i in range(received.size() - 1, -1, -1):
        if received[i][0] < tick:
            received.remove(i)

func clear():
    sent.clear()
    received.clear()
