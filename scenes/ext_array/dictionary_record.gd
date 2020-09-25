class_name DictionaryRecord
extends Record

var dictionary: Dictionary

func _init(init_dictionary: Dictionary):
    dictionary = init_dictionary

func is_empty() -> bool: return false
func head(): pass
func head_or_null(): pass
func tail(): pass
func tail_or_null(): pass
func map(func_ref): return null
func for_each(func_ref): return null
func join(): return null
func filter(func_ref): return null
func find(obj): pass
func find_or_null(obj): pass
func find_index(obj): pass
func find_index_or_null(obj): pass
func fold(acc, func_ref): pass
func size() -> int: return -1
func sort(): return null
func sort_by_field(field_name): return null
func zip(other_array): return null # Returns Tuple
func with(key, value): return null
