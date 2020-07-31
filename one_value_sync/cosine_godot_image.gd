extends Control

export var multiplier = 1

var t = 0

func _process(delta):
    if get_parent() == get_tree().get_root():
        t += delta
    
    var anchor = cos(t * multiplier) * 0.4 + 0.5
    $TextureRect.anchor_bottom = anchor
    $TextureRect.anchor_top = anchor
