class_name Record

func duplicate():
    var duplicate = get_script().new()
    for property in get_property_list():
        if property.usage == 8192:
            if self[property.name] is Node:
                duplicate[property.name] = self[property.name]
            elif self[property.name] is Array:
                duplicate[property.name] = self[property.name].duplicate()
            elif self[property.name] is Object and self[property.name].has_method("duplicate"):
                duplicate[property.name] = self[property.name].duplicate()
            else:
                duplicate[property.name] = self[property.name]
    return duplicate

func with(key: String, new_value):
    var result = self.duplicate()
    result[key] = new_value
    return result
