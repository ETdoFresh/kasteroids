class_name TypedContainer
extends Node

signal node_added(node)
signal node_removed(node)

var nodes = []

func _ready():
    for child in get_children():
        nodes.append(child)
        emit_signal("node_added", child)
        if not (child.is_connected("tree_exited", self, "remove_node")):
            child.connect("tree_exited", self, "remove_node")

func remove_node():
    for i in range(nodes.size() - 1, -1, -1):
        var node = nodes[i]
        if not get_children().has(node):
            emit_signal("node_removed", node)
            nodes.remove(i)

func create_rigidbody(rigidbody_scene, position, rotation, rigidbody, speed):
    var instance = create(rigidbody_scene, {},
            {"global_position": position, "global_rotation": rotation})
    instance.add_collision_exception_with(rigidbody)
    
    var relative_velocity = rigidbody.linear_velocity
    instance.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(rotation)

func create(scene, before_ready = {}, after_ready = {}):
    return add(scene.instance(), before_ready, after_ready)

func add(instance, before_ready = {}, after_ready = {}):
    for variable in before_ready:
        if variable in instance:
            instance[variable] = before_ready[variable]
            
    add_child(instance)
    instance.owner = self
    
    for variable in after_ready:
        if variable in instance:
            instance[variable] = after_ready[variable]
    
    emit_signal("node_added", instance)
    instance.connect("tree_exited", self, "remove_node")
    nodes.append(instance)
    
    return instance
