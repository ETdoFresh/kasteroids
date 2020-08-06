extends Node

var repeaats = 6
var history = []

func add(serialized):
    history.insert(0, serialized)
    while history.size() > repeaats:
        history.remove(history.size() - 1)
    return serialize()

func serialize():
    var output = ""
    for item in history:
        output += item + "|"
    return output
