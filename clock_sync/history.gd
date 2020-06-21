extends Node

var sent = []
var receieved = []

func get_sent_from_tick(tick):
    for item in sent:
        if item[0] == tick:
            return item
    return null

func clear_sent_before_tick(tick):
    for i in range(sent.size() - 1, -1, -1):
        if sent[i][0] < tick:
            sent.remove(i)
