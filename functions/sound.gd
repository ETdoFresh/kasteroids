class_name SoundFunctions

static func play_collision_sound(_key: int, object: Dictionary) -> Dictionary:
    if not "node" in object: return object
    if not object.node: return object
    if not "collision_sound" in object.node: return object
    if not "collisions" in object: return object
    if object.collisions.size() == 0: return object
    # TODO: if collision.force > sound_force:
    object.node.collision_sound.play()
    return object
