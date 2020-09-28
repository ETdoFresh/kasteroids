class_name FPCollisions

static func can_collide(pair: CollisionPairRecord):
    return "bounding_box" in pair.record1 \
        and "bounding_box" in pair.record2

static func broad_phase_search(pair: CollisionPairRecord):
    if pair.record1.bounding_box.get_left() > pair.record2.bounding_box.get_right():
        return false
    if pair.record2.bounding_box.get_left() > pair.record1.bounding_box.get_right():
        return false
    if pair.record1.bounding_box.get_top() > pair.record2.bounding_box.get_bottom():
        return false
    if pair.record2.bounding_box.get_top() > pair.record1.bounding_box.get_bottom():
        return false
    else:
        return true

static func narrow_phase_search(_pair: CollisionPairRecord):
    # TODO: Implement real narrow search
    return true

static func add_collision_info(pair: CollisionPairRecord):
    return pair.with("collision", CollisionRecord.new() \
        .init(pair.record2, get_position(pair), get_normal(pair)))

static func get_position(pair: CollisionPairRecord):
    # TODO: Find collision position... this is not it...
    var position = pair.record1.position.value
    return PositionRecord.new().init(position)

static func get_normal(pair: CollisionPairRecord):
    # TODO: Find collision normal... this is not it...
    var normal = pair.record2.position.value - pair.record1.position.value
    return NormalRecord.new().init(normal)

static func write_first_detected_collision(pairs: CollisionPairsRecord, record: Record):
    var get_pair_by_record = funcref(FPFunctions, "get_pair_by_record")
    var baker = FPBake.new().init(get_pair_by_record, record)
    var get_pair_by_record_bake_record = baker.get_funcref()
    var get_first_detected_collision = funcref(FPFunctions, "get_first_detected_collision")
    var closest_collision = pairs \
        .filter(get_pair_by_record_bake_record) \
        .reduce(NoCollisionRecord.new(), get_first_detected_collision)
    return record.with("collision", closest_collision)

static func has_collided(record: Record):
    return "collision" in record \
        and record.collision is CollisionRecord

static func bounce(record: Record):
    # TODO: Implement bounce()
    return record
