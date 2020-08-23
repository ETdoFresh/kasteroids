extends CollisionShape2D

var rid = -1

func _ready():
    rid = Physics2DServer.rectangle_shape_create()
    Physics2DServer.shape_set_data(rid, shape.extents)
