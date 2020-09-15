class_name ListFunctions

static func copy(list : Array, deep : bool = false) -> Array:
    return list.duplicate(deep)

static func concat(list1 : Array, list2 : Array) -> Array:
    return list1 + list2

static func append(list : Array, value) -> Array:
    var result = copy(list)
    result.append(value)
    return result

static func update(list: Array, index: int, value):
    list = list.duplicate()
    list[index] = value
    return list

static func map(list : Array, func_ref : FuncRef) -> Array:
    var result = []
    result.resize(list.size())
    for i in range(list.size()):
        result[i] = func_ref.call_func(list[i])
    return result

static func filter(list : Array, func_ref : FuncRef) -> Array:
    var result = []
    for item in list:
        if func_ref.call_func(item):
            result.append(item)
    return result

static func not_filter(list : Array, func_ref : FuncRef) -> Array:
    var result = []
    for item in list:
        if not func_ref.call_func(item):
            result.append(item)
    return result

static func reduce(list: Array, func_ref: FuncRef, first = null):
    var accumulator = first
    var start = 0
    if accumulator == null:
        accumulator = list[0]
        start = 1
    for i in range(start, list.size()):
        accumulator = func_ref.call_func(accumulator, list[i])
    return accumulator

static func map1(list : Array, func_ref : FuncRef, arg) -> Array:
    var result = []
    result.resize(list.size())
    for i in range(list.size()):
        result[i] = func_ref.call_func(list[i], arg)
    return result

static func find(list: Array, func_ref: FuncRef):
    for i in range(list.size()):
        if list[i] == func_ref.call_func(list[i]):
            return list[i]

static func find_index(list: Array, func_ref: FuncRef) -> int:
    for i in range(list.size()):
        if list[i] == func_ref.call_func(list[i]):
            return i
    return -1

static func fill(list: Array, index: int, func_ref: FuncRef):
    for i in range(index, list.size()):
        list[i] = func_ref.call_func(list[i])

static func copy_within(list: Array, from_i: int, to_i: int):
    list[to_i] = list[from_i]

static func some(list: Array, func_ref: FuncRef) -> bool:
    for i in range(list.size()):
        if func_ref.call_func(list[i]):
            return true
    return false

static func every(list: Array, func_ref: FuncRef) -> bool:
    for i in range(list.size()):
        if func_ref.call_func(list[i]):
            return false
    return true
