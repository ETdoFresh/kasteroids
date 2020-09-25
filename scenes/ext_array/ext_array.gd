class_name ExtArray

var array: Array

func _init(init_array: Array = []):
    array = init_array

func is_empty() -> bool: return false
func head(): pass
func head_or_null(): pass
func tail(): pass
func tail_or_null(): pass
func map(func_ref) -> ExtArray: return null
func for_each(func_ref) -> ExtArray: return null
func join() -> ExtArray: return null
func filter(func_ref) -> ExtArray: return null
func find(obj): pass
func find_or_null(obj): pass
func find_index(obj): pass
func find_index_or_null(obj): pass
func fold(acc, func_ref): pass
func size() -> int: return -1
func sort() -> ExtArray: return null
func sort_by_field(field_name) -> ExtArray: return null
func zip(other_array) -> ExtArray: return null # Returns Tuple
