extends Node2D

const ShipScene = preload("res://entities/ship/ship.tscn")
const PlayerScene = preload("res://entities/player/player.tscn")

func _enter_tree():
    for child in get_children():
        if child is TypedContainer:
            child.connect("node_added", $Serializer, "track_node")
            child.connect("node_removed", $Serializer, "untrack_node")
    
    #warning-ignore:return_value_discarded
    $Ships.connect("node_added", self, "listen_for_bullets")

func listen_for_bullets(ship):
    ship.connect("create", $Bullets, "create_rigidbody")

func serialize():
    return $Serializer.serialize()

func create_player(input):
    var ship = $Ships.create(ShipScene, {"input": input})
    ship.set_position(Vector2(630, 360))
    $Players.create(PlayerScene, {"ship": ship, "input": input})
    $PlayerMonitor.add_player_input(input)

func delete_player(input):
    for player in $Players.get_children():
        if player.input == input:
            player.ship.queue_free()
            player.queue_free()
        
    $PlayerMonitor.remove_player_input(input)
