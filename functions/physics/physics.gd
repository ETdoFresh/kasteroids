class_name PhysicsFunctions

const COLLISION = CollisionFunctions
const LIST = ListFunctions
const PHYSICS_NODES = PhysicsNodesFunctions

static func simulate(objects: Array, delta: float) -> Array:
    objects = objects.duplicate()
    objects = LIST.map(objects, funcref(COLLISION, "clear_collisions"))
    objects = LIST.map(objects, funcref(PHYSICS_NODES, "update_physical_body")) # Side-effect
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "move"), delta)
    objects = LIST.map1(objects, funcref(PHYSICS_NODES, "collide"), objects)
    objects = LIST.map(objects, funcref(COLLISION, "fix_penetration"))
    objects = LIST.map(objects, funcref(COLLISION, "bounce_no_angular_velocity"))
    return objects
