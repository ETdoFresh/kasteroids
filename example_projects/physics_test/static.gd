extends Node2D

var rid = -1

func _ready():
    rid = Physics2DServer.body_create()
    Physics2DServer.body_set_mode(rid, Physics2DServer.BODY_MODE_STATIC)
    Physics2DServer.body_add_shape(rid, $CollisionShape2D.rid, global_transform)
    Physics2DServer.body_set_collision_layer(rid, 1)
    Physics2DServer.body_set_collision_mask(rid, 0)
    Physics2DServer.body_set_state(rid, Physics2DServer.BODY_STATE_TRANSFORM, global_transform)

func _physics_process(delta):
    Physics2DServer.body_add_force(rid, Vector2.ZERO, Vector2.DOWN * 9.8)
    var state = Physics2DServer.body_get_direct_state(rid)
    state.integrate_forces()
    global_transform = state.transform
