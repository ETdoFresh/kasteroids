extends Control

export (Array, NodePath) var player_uis

var player_inputs = []

#warning-ignore:unused_argument
func _process(delta):
    for i in range(player_inputs.size()):
        var player_input = player_inputs[i]
        var player_ui = get_node(player_uis[i])
        player_ui.player_name.text = "Local Player!" #player.player_name
        player_ui.player_up.pressed = player_input.vertical < 0
        player_ui.player_down.pressed = player_input.vertical > 0
        player_ui.player_left.pressed = player_input.horizontal < 0
        player_ui.player_right.pressed = player_input.horizontal > 0
        player_ui.player_fire.pressed = player_input.fire
