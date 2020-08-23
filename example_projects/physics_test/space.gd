extends Node2D

var rid = -1

func _ready():
    rid = Physics2DServer.space_create()
    Physics2DServer.body_set_space($StaticBody.rid, rid)
    Physics2DServer.body_set_space($RigidBody.rid, rid)
    Physics2DServer.space_set_active(rid, true)
