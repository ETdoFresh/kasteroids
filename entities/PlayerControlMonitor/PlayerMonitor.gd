extends Control

export (Array, NodePath) var assignedControllers

export (NodePath) var assignedController1Path
export (NodePath) var assignedController2Path
export (NodePath) var assignedController3Path
export (NodePath) var assignedController4Path

export (Array, NodePath) var player_containers

func _process(delta):
    for i in range(assignedControllers.size()):
        
        if not has_node(assignedControllers[i]): continue
        
        var assignedController = get_node(assignedControllers[i])
        var player_container = get_node(player_containers[i])
        player_container.player_name.text = assignedController.player_name
        player_container.player_up.pressed = assignedController.vertical > 0
        player_container.player_down.pressed = assignedController.vertical < 0
        player_container.player_left.pressed = assignedController.horizontal < 0
        player_container.player_right.pressed = assignedController.horizontal > 0
        player_container.player_fire.pressed = assignedController.fire
