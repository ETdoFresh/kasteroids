extends Node2D

const ShipScene = preload("res://entities/ship/ship.tscn")

var horizontal = 0
var vertical = 0
var fire = false
var next_state = false
var previous_state = false

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
    
    $Overlay.add_stat("Player_State", $Ships/Ship/States, "active_state_name", false)
    $Overlay.add_stat("Player Position", $Ships/Ship, "position", false)
    $Overlay.add_stat("Player Rotation", $Ships/Ship, "rotation", false)
    $Overlay.add_stat("Player Scale", $Ships/Ship, "scale", false)

func _process(_delta):
    for ship in $Ships.get_children():
        Util.copy_input_variables(self, ship)

func listen_for_bullets(ship):
    ship.connect("create", $Bullets, "create_rigidbody")

func create_ship():
    $Ships.create(ShipScene, Vector2(1280/2, 720/2))

func serialize():
    $Serializer.serialize()
