extends Node2D

var physics_space
var variables = {}

onready var cube = $World/Cube
onready var cube_rid = cube.get_rid()
onready var cube_space = Physics2DServer.body_get_space(cube_rid)
onready var world_space = get_world_2d().space
onready var spaces_equal = world_space == cube_space
onready var cube_space_equal = cube_space == cube_rid
onready var future = $FutureWorld
onready var world = $World

func _ready():
    future.world_history = world.history

func _input(event):
    if event is InputEventKey:
        if event.is_pressed():
            if not event.is_echo():
                if event.scancode == KEY_N:
                    var body_state = Physics2DServer.body_get_direct_state(cube_rid)
                    body_state.integrate_forces()

## I'm not sure that I'll see this again... but I think I'll just come back to manually stepping once it is easier....
## but for now, I'll go ahead and just start trying to structure the demo/game that will have a world.simulate()...
## which will in turn simulate the world at any given time step... physics is ignored for now until manually stepping....
## game logic will not be ignored! ok, here i go...
