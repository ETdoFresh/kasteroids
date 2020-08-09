extends Node

var time = 0
var value = 0
var data = []
var count = 0

func _process(delta):
    time += delta
    remove_data_less_than_one_second()
    value = sum_data() * 8.0 / 1000

func add_data(message : String):
    data.append([time, message.length()])
    count += 1

func add_client_data(_client, message : String):
    data.append([time, message.length()])
    count += 1

func remove_data_less_than_one_second():
    for i in range(data.size() - 1, -1, -1):
        if data[i][0] < time - 1:
            data.remove(i)
            count -= 1

func sum_data():
    var sum = 0
    for d in data:
        sum += d[1]
    return sum
