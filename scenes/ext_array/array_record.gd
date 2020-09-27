class_name ArrayRecord
extends Record

var array: Array = []

func init(init_array: Array):
    var init = duplicate()
    init.array = init_array
    return init

func duplicate():
    var duplicate = get_script().new()
    duplicate.array = array.duplicate()
    return duplicate

func append(item):
    var result = duplicate()
    result.array.append(item)
    return result

func concat(other_array_record: ArrayRecord):
    var result = duplicate()
    for item in other_array_record.array:
        result.array.append(item)
    return result

func is_empty() -> bool: return array.size() > 0
func head(): return array[0]
func head_or_null(): return null if is_empty() else array[0]
func tail(): return array[array.size() - 1]
func tail_or_null(): return null if is_empty() else array[array.size() - 1]

func pairs():
    var result = get_script().new()
    for i in array.size():
        for j in array.size():
            if i != j:
                result.array.append([array[i], array[j]])
    return result

func map(func_ref: FuncRef):
    var result = duplicate()
    for i in range(array.size()):
        result.array[i] = func_ref.call_func(array[i])
    return result

func map_only(filter_func: FuncRef, map_func: FuncRef):
    var result = duplicate()
    for i in range(array.size()):
        if filter_func.call_func(array[i]):
            result.array[i] = map_func.call_func(array[i])
            continue
    return result

func for_each(func_ref: FuncRef):
    return map(func_ref)

func join(): return null

func filter(func_ref):
    var result = duplicate()
    result.array = []
    for i in range(array.size()):
        if func_ref.call_func(array[i]):
            result.array.append(array[i])
    return result

func find(_obj): pass
func find_or_null(_obj): pass
func find_index(_obj): pass
func find_index_or_null(_obj): pass
func fold(_acc, _func_ref): pass
func size() -> int: return -1
func sort(): return null
func sort_by_field(_field_name): return null
func zip(_other_array): return null # Returns Tuple
