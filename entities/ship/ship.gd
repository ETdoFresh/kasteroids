class_name Ship
extends Node2D

signal gun_fired(gun_position, gun_rotation, ship, velocity_magnitude)

var id = -1
var input = InputData.new()
var collision_layer setget set_collision_layer
var collision_mask setget set_collision_mask
var linear_velocity = Vector2.ZERO
var angular_velocity = 0
var mass = 1.0
var username = ""

onready var state_machine = $States

func _process(_delta):
    $Name.position = state_machine.active_state.position
    $Name/Label.text = username

func _physics_process(_delta):
    if input.fire:
        if state_machine.active_state:
            if state_machine.active_state.has_node("Gun"):
                var gun = state_machine.active_state.get_node("Gun")
                if gun.is_ready:
                    gun.fire()
                    emit_signal("gun_fired", gun.global_position, gun.global_rotation, state_machine.active_state, gun.shoot_velocity)
    
    # Just some DEBUG code to test different states...
    if input.previous_state:
        state_machine.set_previous_state()
    elif input.next_state:
        state_machine.set_next_state()

    if state_machine && state_machine.active_state && state_machine.active_state.get_node("CollisionShape2D"):
        var state = state_machine.active_state
        linear_velocity = state.linear_velocity if state.get("linear_velocity") else Vector2.ZERO
        angular_velocity = state.angular_velocity if state.get("angular_velocity") else 0

func state_name():
    return state_machine.active_state_name

func update_input(update_input):
    for key in input.keys():
        if key in update_input:
            input[key] = update_input[key]
    
    if update_input.get("username"): username = update_input.username
    
    if state_machine:
        for state in state_machine.states:
            if "input" in state:
                for key in state.input.keys():
                    if key in update_input:
                        state.input[key] = update_input[key]
    

func set_position(new_position):
    position = new_position
    var state = state_machine.active_state
    if state is RigidBody2D:
        state.global_position = new_position

func set_collision_layer(value):
    collision_layer = value
    for state in $States.get_children():
        if state.get("collision_layer"):
            state.collision_layer = collision_layer

func set_collision_mask(value):
    collision_mask = value
    for state in $States.get_children():
        if state.get("collision_mask"):
            state.collision_mask = collision_mask

func linear_interpolate(other, t):
    if $States.active_state && $States.active_state.has_method("linear_interpolate"):
        $States.active_state.linear_interpolate(other, t)

func to_dictionary():
    var state = get_active_state()
    return {
        "id": id,
        "type": "Ship",
        "position": state.global_position if state else -Vector2.ONE,
        "rotation": state.global_rotation if state else -1,
        "scale": state.get_node("CollisionShape2D").scale if state else -Vector2.ONE,
        "linear_velocity": state.linear_velocity if state else -Vector2.ONE,
        "angular_velocity": state.angular_velocity if state else -1,
        "username": username }

func from_dictionary(dictionary):
    var state = get_active_state()
    if dictionary.has("id"): id = dictionary["id"]
    if state:
        if dictionary.has("position"): state.queue_position(dictionary["position"])
        if dictionary.has("rotation"): state.queue_rotation(dictionary["rotation"])
        if dictionary.has("scale"): state.get_node("CollisionShape2D").scale = dictionary["scale"]
        if dictionary.has("linear_velocity"): state.linear_velocity = dictionary["linear_velocity"]
        if dictionary.has("angular_velocity"): state.angular_velocity = dictionary["angular_velocity"]

func get_active_state():
    if state_machine and state_machine.active_state:
        return state_machine.active_state
    else:
        return null
