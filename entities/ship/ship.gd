class_name Ship
extends Node2D

#warning-ignore:unused_signal
signal gun_fired(gun_position, gun_rotation, ship, velocity_magnitude)

var input = Data.NULL_INPUT
var collision_layer setget set_collision_layer
var collision_mask setget set_collision_mask
var linear_velocity
var angular_velocity

onready var state_machine = $States
onready var data = $Data

func init(init_input):
    input = init_input
    return self

func _ready():
    var _1 = data.connect("deserialized", self, "on_deserialized")
    update_input(input)

func _process(_delta):
    $Name.position = state_machine.active_state.position

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
        var id = get_instance_id()
        data.update(id, name, state.global_position, state.global_rotation, state.get_node("CollisionShape2D").scale, linear_velocity, angular_velocity)

func on_deserialized():
    $States/Normal/Name/Label.text = data.instance_name

func state_name():
    return state_machine.active_state_name

func update_input(new_input):
    input = new_input
    for state in state_machine.states:
        if "input" in state:
            state.input = input

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
