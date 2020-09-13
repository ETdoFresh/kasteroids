class_name PhysicsFunctions

const COLLISION = CollisionFunctions
const LIST = ListFunctions
const PHYSICS_NODES = PhysicsNodesFunctions

static func simulate(objects: Array, delta: float) -> Array:
    objects = objects.duplicate()
    objects = LIST.map(objects, funcref(PHYSICS_NODES, "setup_physical_body")) # Side-effect
    objects = LIST.map(objects, funcref(COLLISION, "clear_collision"))
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "move_and_collide"), delta) # Side-effect + Update
    objects = LIST.map(objects, funcref(PHYSICS_NODES, "update_object_from_physical_body"))
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "replace_collision_with_dictionary"), objects)
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "add_collision_to_other_collider"), objects)
    objects = LIST.map(objects, funcref(COLLISION, "bounce_no_angular_velocity"))
    return objects
