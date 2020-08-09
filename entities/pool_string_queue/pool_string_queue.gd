class_name PoolStringQueue

var pool_string_array : PoolStringArray

func _init(init_pool_string_array = null):
    pool_string_array = init_pool_string_array
    if pool_string_array == null:
        pool_string_array = PoolStringArray([])

func pop_front():
    if pool_string_array.size() == 0:
        return null
    
    var value = pool_string_array[0]
    pool_string_array.remove(0)
    return value
