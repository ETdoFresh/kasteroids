class_name ArrayRecord
extends Record

var array: Array

func _init(init_array: Array):
    array = init_array

func copy():
    return get_script().new(array.duplicate())

func is_empty() -> bool: return array.size() > 0
func head(): return array[0]
func head_or_null(): return null if is_empty() else array[0]
func tail(): return array[array.size() - 1]
func tail_or_null(): return null if is_empty() else array[array.size() - 1]

func map(func_ref: FuncRef):
    var result = copy()
    for i in range(array.size()):
        result.array[i] = func_ref.call_func(array[i])
    return result

func for_each(func_ref: FuncRef):
    return map(func_ref)

func join(): return null

func filter(func_ref):
    var result = copy()
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
