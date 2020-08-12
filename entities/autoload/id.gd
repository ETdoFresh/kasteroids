extends Node

const MAX_ID = 1000000000

var last_assigned = -1
var used = []

func reserve():
    for i in range(MAX_ID):
        var new_id = (last_assigned + 1 + i) % MAX_ID
        if not used.has(new_id):
            used.append(new_id)
            return new_id

func release(id):
    used.erase(id)
