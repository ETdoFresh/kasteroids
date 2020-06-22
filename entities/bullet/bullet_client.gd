class_name BulletClient
extends BaseNode2D

func receive_update(state):
    if get_node("Interpolation"):
        $Interpolation.add_history(state)
    
    if get_node("Latest"):
        $Latest.position = state.position
        $Latest.rotation = state.rotation
        $Latest.scale = state.scale
