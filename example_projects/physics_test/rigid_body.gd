extends Node2D

var rid = -1

func _ready():
    rid = Physics2DServer.body_create()
    Physics2DServer.body_set_mode(rid, Physics2DServer.BODY_MODE_RIGID)
    Physics2DServer.body_add_shape(rid, $CollisionShape2D.rid, global_transform)
    Physics2DServer.body_set_collision_layer(rid, 1)
    Physics2DServer.body_set_collision_mask(rid, 0)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_BOUNCE, 0)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_FRICTION, 1)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_MASS, 1)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_GRAVITY_SCALE, -1)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_LINEAR_DAMP, -1)
    Physics2DServer.body_set_param(rid, Physics2DServer.BODY_PARAM_ANGULAR_DAMP, -1)
    Physics2DServer.body_set_state(rid, Physics2DServer.BODY_STATE_TRANSFORM, global_transform)
    
    #Physics2DServer.body_attach_object_instance_id(rid, get_instance_id())

func _physics_process(delta):
    var state = Physics2DServer.body_get_direct_state(rid)
    global_transform = state.transform
