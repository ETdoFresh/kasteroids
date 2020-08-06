class_name SlidingWindow

enum Algorithm {MEDIAN, MAX, AVERAGE}

var size = 3
var sliding_window = []
var algorithm

func _init(init_size, init_algorithm = Algorithm.MAX):
    size = init_size
    algorithm = init_algorithm

func add(value):
    sliding_window.append(value)
    while sliding_window.size() > size:
        sliding_window.remove(0)
    return get_value()

func get_value():
    if algorithm == Algorithm.AVERAGE:
        return average_value()
    if algorithm == Algorithm.MEDIAN:
        return median_value()
    else:
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

func median_value():
    if sliding_window.size() == 0: 
        return 0
        
    var ordered_sliding_window = sliding_window.duplicate()
    ordered_sliding_window.sort()
    if ordered_sliding_window.size() % 2 == 1: 
        return ordered_sliding_window[ordered_sliding_window.size() / 2]
    else:
        return (ordered_sliding_window[ordered_sliding_window.size() / 2] +
            ordered_sliding_window[ordered_sliding_window.size() / 2 - 1]) / 2
