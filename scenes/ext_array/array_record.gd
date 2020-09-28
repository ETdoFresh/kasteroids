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

func is_empty() -> bool:
    return array.size() > 0

func head():
    return array[0]

func head_or_null():
    return null if is_empty() else array[0]

func tail():
    return array[array.size() - 1]

func tail_or_null():
    return null if is_empty() else array[array.size() - 1]

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

func fold(accumulator, func_ref):
    return reduce(accumulator, func_ref)

func reduce(accumulator, func_ref):
    for i in range(array.size()):
        accumulator = func_ref.call_func(accumulator, array[i])
    return accumulator

func find(obj):
    for i in range(array.size()):
        if obj == array[i]:
            return obj
    push_error("Could not find obj %s" % obj)

func find_or_null(obj):
    for i in range(array.size()):
        if obj == array[i]:
            return obj
    return null

func find_index(obj):
    for i in range(array.size()):
        if obj == array[i]:
            return i
    push_error("Could not find obj %s" % obj)

func find_index_or_null(obj):
    for i in range(array.size()):
        if obj == array[i]:
            return i
    return null

func size() -> int:
    return array.size()

func sort():
    var result = duplicate()
    array.sort()
    return result

func sort_by_field(field_name):
    var result = duplicate()
    _field_name = field_name
    array.sort_custom(self, "_array_sort_by_field")
    return result

var _field_name
func _array_sort_by_field(a, b):
    return a[_field_name] < b[_field_name]

func zip(other_array):
    var result = duplicate()
    for i in range(array.size()):
        result.array[i] = [array[i], other_array[i]]
    return result
