class_name FPWorld

func new_state(): 
    return StateRecord.new().init(0, ObjectsRecord.new().init([]))

func ready(world: Node):
    return new_state() \
        .with("objects", ObjectsRecord.new().init(world.get_children()) \
            .map(funcref(self, "from_node_to_record")) \
            .filter(funcref(self, "is_not_null")))

func process(state: StateRecord, delta: float, world: Node):
    return state \
        .with("tick", state.tick + 1) \
        .with("objects", state.objects \
            .apply_input() \
            .queue_create_bullets() \
            .limit_velocity() \
            .apply_angular_velocity(delta) \
            .apply_linear_acceleration(delta) \
            .apply_linear_velocity(delta) \
            .wrap_around_the_screen() \
            .update_nodes(world)
#            .set_cooldowns() \
#            .add_new_collisions() \
#            .resolve_collisions() \
#            .queue_delete_bullet_on_collide() \
#            .queue_delete_bullet_on_timeout() \
#            .delete_objects() \
#            .create_objects() \
        )

func from_node_to_record(node: Node):
    if node.has_method("get_record"):
        return node.get_record()
    else:
        return null

func is_not_null(obj: Object):
    return obj != null

## Objects File
func duplicate(): pass
func concat(_d1, _d2): pass
func remove(_t): pass
func filter(_t): pass
func map(_a): pass
func map_only(_a, _b): pass
func apply_input():
    return map_only("is_ship", "apply_input")
func queue_create_bullets():
    return concat(self, self \
        .filter("is_ship_firing") \
        .map("convert_to_new_bullets"))
func set_cooldowns():
    return map_only("is_ship", "set_cooldowns")
func move():
    return map_only("is_moving", "apply_movement")
func spin():
    return map_only("is_spinning", "apply_spin")
func collide():
    var shapes = filter("has_shape")
    var pairs = shapes.join(shapes, "is_not_equals")
    var collisions = pairs \
        .broad_phase() \
        .narrow_phase() \
        .get_closest_collision()
    return filter("not_has_shape") \
        .concat(shapes \
            .join(collisions, "on_shape"))
func resolve_collisions():
    return self \
        .map_only("has_collision", "fix_penetration") \
        .map_only("has_collision", "bounce")
func queue_delete_bullet_on_collide():
    return map_only("is_bullet_has_collision", "add_queue_delete")
func queue_delete_bullet_on_timeout():
    return map_only("is_bullet_has_timeout", "add_queue_delete")
func delete_objects():
    var _side_effect = self \
        .filter("has_queue_delete") \
        .map("delete_node")
    return filter("not_has_queue_delete")
func create_objects():
    return self \
        .map_only("is_ship_node_null", "create_ship_node") \
        .map_only("is_asteroid_node_null", "create_asteroid_node") \
        .map_only("is_bullet_node_null", "create_bullet_node")
func update_objects():
    var _side_effect = map("apply_record_to_node")
    return self
