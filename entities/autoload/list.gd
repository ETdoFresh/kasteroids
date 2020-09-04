extends Node

func lookup(list, key, value):
    for item in list:
        if item:
            if key in item:
                if item[key] == value:
                    return item
    return null
