extends Node2D

const PlayerScene = preload("res://entities/player/player.tscn")
const ShipScene = preload("res://entities/ship/ship.tscn")

func _ready():
    for child in get_children():
        if child is TypedContainer:
            child.connect("node_added", $Serializer, "track_node")
            child.connect("node_removed", $Serializer, "untrack_node")
            
            # Because children scripts go first, manually connecting Serializer here...
            for item in child.get_children():
                $Serializer.track_node(item)
            
    for ship in $Ships.get_children():
        listen_for_bullets(ship)
    
    #warning-ignore:return_value_discarded
    $Ships.connect("node_added", self, "listen_for_bullets")

func _process(_delta):
    for ship in $Ships.get_children():
        Util.copy_input_variables(self, ship)

func listen_for_bullets(ship):
    ship.connect("create", $Bullets, "create_rigidbody")

func serialize():
    $Serializer.serialize()

func create_player(input):
    var ship = $Ships.create(ShipScene, {"input": input})
    ship.set_position(Vector2(630, 360))
    var player = $Players.create(PlayerScene, {"ship": ship, "input": input})
    
    $Overlay.add_stat("Player_State", ship, "state_name", true)
    $Overlay.add_stat("Player Position", ship, "position", false)
    $Overlay.add_stat("Player Rotation", ship, "rotation", false)
    $Overlay.add_stat("Player Scale", ship, "scale", false)
    
    $PlayerMonitor.player_inputs.append(player.input)
