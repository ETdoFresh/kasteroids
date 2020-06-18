class_name TypedContainer
extends Node2D

signal node_added(node)
signal node_removed(node)

var nodes = []

func _ready():
    for child in get_children():
        emit_signal("node_added", child)
        child.connect("tree_exited", self, "remove_node")
        nodes.append(child)

func remove_node():
    for i in range(nodes.size() - 1, -1, -1):
        var node = nodes[i]
        if not get_children().has(node):
            emit_signal("node_removed", node)
            nodes.remove(i)

func create(scene, position = null, rotation = null):
    var instance = scene.instance()
    add_child(instance)
    instance.owner = self
    
    if position != null: instance.global_position = position
    if rotation != null: instance.global_rotation = rotation
    
    emit_signal("node_added", instance)
    instance.connect("tree_exited", self, "remove_node")
    nodes.append(instance)
    
    return instance

func create_rigidbody(scene, position, rotation, rigidbody, speed):
    var instance = create(scene, position, rotation)
    instance.add_collision_exception_with(rigidbody)
    
    var relative_velocity = rigidbody.linear_velocity
    instance.linear_velocity = relative_velocity + Vector2(0, -speed).rotated(rotation)
