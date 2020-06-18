extends Node

const INPUT_VARIABLES = ["horizontal", "vertical", "fire", "next_state", "previous_state"]

func copy_input_variables(source, destination):
    for variable in INPUT_VARIABLES:
        if variable in source && variable in destination:
            destination[variable] = source[variable]

func find_parent_of_type_if_not_set(node, dest_node, type):
    if dest_node != null:
        return dest_node
    
    var parent = node.get_parent()
    while parent != null:
        if parent is type:
            return parent
        else:
            parent = parent.get_parent()
    
    return null
