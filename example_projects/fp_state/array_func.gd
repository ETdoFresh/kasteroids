class_name ArrayFunc

static func map(array: Array, func_name: String):
    for i in range(array.size()):
        if func_name in array[i]:
            array[i] = array[i][func_name].call_func(array[i])
    return array

static func map1(array: Array, func_name: String, arg): # 1 arg
    for i in range(array.size()):
        if func_name in array[i]:
            array[i] = array[i][func_name].call_func(array[i], arg)
    return array

static func fold(array: Array, func_name: String, accumulator):
    var duplicate = array.duplicate()
    for i in range(duplicate.size()):
        if func_name in duplicate[i]:
            accumulator = duplicate[i][func_name].call_func(duplicate[i], accumulator)
    return accumulator

static func fold1(array: Array, func_name: String, accumulator, arg):
    var duplicate = array.duplicate()
    for i in range(duplicate.size()):
        if func_name in duplicate[i]:
            accumulator = duplicate[i][func_name].call_func(duplicate[i], accumulator, arg)
    return accumulator

