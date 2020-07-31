class_name SlidingWindow

var size = 3
var sliding_window = []

func _init(init_size):
    size = init_size

func add(value):
    sliding_window.append(value)
    while sliding_window.size() > size:
        sliding_window.remove(0)
    return max_value()

func average_value():
    if sliding_window.size() == 0:
        return 0
    
    var sum = 0
    for value in sliding_window:
        sum += value
    return sum / sliding_window.size()

func max_value():
    var max_val = 0
    for value in sliding_window:
        if max_val < value:
            max_val = value
    return max_val
