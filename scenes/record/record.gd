class_name Record

func copy():
    return get_script().new()

func with(key: String, new_value):
    var result = self.copy()
    result[key] = new_value
    return result
