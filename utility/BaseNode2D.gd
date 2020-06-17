extends Node2D

class_name BaseNode2D

func _enter_tree():
    var world = get_parent()
    world.add_state_node(self)

func _exit_tree():
    var world = get_parent()
    world.remove_state_node(self)

func get_child_of_type_in_node(node, type):
    for child in node.get_children():
        if child is type:
            return child
    return null

func get_child_of_type(type):
    return get_child_of_type_in_node(self, type)

func get_child_of_type_in_parent(type):
    var found_in_parent = get_child_of_type_in_node(get_parent(), type)
    if found_in_parent:
        return found_in_parent
    else:
        return get_child_of_type(type)

func get_child_of_type_in_children(type, recurse = true):
    var found_in_self = get_child_of_type_in_node(self, type)
    if found_in_self:
        return found_in_self
    else:
        return get_child_of_type_in_node_recursive(self, type, recurse)

func get_child_of_type_in_node_recursive(node, type, recurse = true):
    for child in node.get_children():
        var found_in_child = get_child_of_type_in_node(child, type)
        if found_in_child:
            return child
        
        if recurse:
            for child in node.get_children():
                var found_in_recursion = get_child_of_type_in_node_recursive(child, type, recurse)
                if found_in_recursion:
                    return found_in_recursion
    
    return null
