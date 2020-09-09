extends Node

static func copy(list : Array, deep : bool = false) -> Array:
    return list.duplicate(deep)

static func concat(list1 : Array, list2 : Array) -> Array:
    return list1 + list2

static func append(list : Array, value) -> Array:
    var result = copy(list)
    result.append(value)
    return result

static func map(list : Array, func_ref : FuncRef) -> Array:
    var result = []
    result.resize(list.size())
    for i in range(list.size()):
        result[i] = func_ref.call_func(list[i])
    return result

static func map1(list : Array, func_ref : FuncRef, arg) -> Array:
    var result = []
    result.resize(list.size())
    for i in range(list.size()):
        result[i] = func_ref.call_func(list[i], arg)
    return result

static func filter(list : Array, func_ref : FuncRef) -> Array:
    var result = []
    for item in list:
        if func_ref.call_func(item):
            result.append(item)
    return result
