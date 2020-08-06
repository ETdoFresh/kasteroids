extends Control

export (Array, NodePath) var player_uis

var player_inputs = []

func _process(_delta):
    for i in range(player_uis.size()):
        var player_ui = get_node(player_uis[i])
        
        if player_inputs.size() > i:
            var player_input = player_inputs[i]
            player_ui.player_name.text = player_input.input_name
            player_ui.player_up.pressed = player_input.vertical < 0
            player_ui.player_down.pressed = player_input.vertical > 0
            player_ui.player_left.pressed = player_input.horizontal < 0
            player_ui.player_right.pressed = player_input.horizontal > 0
            player_ui.player_fire.pressed = player_input.fire
        else:
            player_ui.player_name.text = "<Unassigned>"
            player_ui.player_up.pressed = false
            player_ui.player_down.pressed = false
            player_ui.player_left.pressed = false
            player_ui.player_right.pressed = false
            player_ui.player_fire.pressed = false

func add_player_input(input):
    player_inputs.append(input)

func remove_player_input(input):
    player_inputs.erase(input)
