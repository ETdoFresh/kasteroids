extends Node

var history = {}
var node_positions = {}
var node_rotations = {}
var node_linear_velocities = {}
var node_angular_velocities = {}

onready var world = get_parent()

func _ready():
    add_state()

func _physics_process(_delta):
    add_state()

func add_state():
    var state = {}
    for child in world.get_children():
        if child is RigidBody2D:
            state[child.name] = {
                "position": child.position, 
                "rotation": child.rotation,
                "linear_velocity": child.linear_velocity,
                "angular_velocity": child.angular_velocity,
            }
    history[world.tick] = state
    erase_future_ticks(world.tick)
    
    for child in world.get_children():
        if child is RigidBody2D:
            if not node_positions.has(child.name):
                node_positions[child.name] = {}
                node_rotations[child.name] = {}
                node_linear_velocities[child.name] = {}
                node_angular_velocities[child.name] = {}
            node_positions[child.name][world.tick] = child.position
            node_rotations[child.name][world.tick] = child.rotation
            node_linear_velocities[child.name][world.tick] = child.linear_velocity
            node_angular_velocities[child.name][world.tick] = child.angular_velocity

func set_to_tick(tick):
    if not history.has(tick):
        return
    
    for child in world.get_children():
        if child is RigidBody2D:
            child.queue_position(history[tick][child.name].position)
            child.queue_rotation(history[tick][child.name].rotation)
            child.linear_velocity = history[tick][child.name].linear_velocity
            child.angular_velocity = history[tick][child.name].angular_velocity

func erase_future_ticks(tick):
    for i in range(history.size() - 1, tick, -1):
        history.erase(i)
        for child in world.get_children():
            if child is RigidBody2D:
                node_positions[child.name].erase(i)
                node_rotations[child.name].erase(i)
                node_linear_velocities[child.name].erase(i)
                node_angular_velocities[child.name].erase(i)

func has_tick(tick):
    return history.has(tick)
