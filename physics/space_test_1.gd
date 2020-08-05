extends Node2D

var rid

onready var physics = Physics2DServer
onready var static_body = $StaticBody2D
onready var static_body_shape = $StaticBody2D/CollisionShape2D
onready var rigid_body = $RigidBody2D
onready var rigid_body_shape = $RigidBody2D/CollisionShape2D

func _ready():
    rid = physics.space_create()
    static_body.rid = physics.body_create()
    rigid_body.rid = physics.body_create()
    physics.body_set_space(static_body.rid, rid)
    physics.body_set_space(rigid_body.rid, rid)
    physics.body_set_mode(static_body.rid, physics.BODY_MODE_STATIC)
    physics.body_set_mode(rigid_body.rid, physics.BODY_MODE_RIGID)
    physics.body_set_param(static_body.rid, Physics2DServer.BODY_PARAM_BOUNCE, 0)
    physics.body_set_param(static_body.rid, Physics2DServer.BODY_PARAM_FRICTION, 1)
    physics.body_set_param(rigid_body.rid, Physics2DServer.BODY_PARAM_BOUNCE, 0)
    physics.body_set_param(rigid_body.rid, Physics2DServer.BODY_PARAM_FRICTION, 1)
    physics.body_set_param(rigid_body.rid, Physics2DServer.BODY_PARAM_GRAVITY_SCALE, 1)
    static_body_shape.rid = physics.rectangle_shape_create()
    rigid_body_shape.rid = physics.rectangle_shape_create()
    physics.shape_set_data(static_body_shape.rid, Vector2(50, 50))
    physics.shape_set_data(rigid_body_shape.rid, Vector2(50, 50))
    physics.body_add_shape(static_body.rid, static_body_shape.rid, static_body.transform)
    physics.body_add_shape(rigid_body.rid, rigid_body_shape.rid, rigid_body.transform)
    physics.body_set_state(static_body.rid, Physics2DServer.BODY_STATE_TRANSFORM, static_body.transform)
    physics.body_set_state(rigid_body.rid, Physics2DServer.BODY_STATE_TRANSFORM, rigid_body.transform)
    physics.space_set_active(rid, true)

func _process(delta):
    #Physics2DServer.step(delta)
    static_body.transform = physics.body_get_state(static_body.rid, Physics2DServer.BODY_STATE_TRANSFORM)
    rigid_body.transform = physics.body_get_state(rigid_body.rid, Physics2DServer.BODY_STATE_TRANSFORM)
