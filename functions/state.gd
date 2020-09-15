class_name StateFunctions

const ASTEROID = AsteroidFunctions
const BULLET = BulletFunctions
const DICTIONARY = DictionaryFunctions
const LIST = ListFunctions
const NODE = NodeFunctions
const OBJECT = ObjectFunctions
const PHYSICS = PhysicsFunctions
const SHIP = ShipFunctions
const SOUND = SoundFunctions
const WRAP = WrapFunctions

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": []}

static func initial_state(children: Array):
    var state = empty_state()
    state.objects = LIST.map(children, funcref(NODE, "to_dictionary"))
    state = OBJECT.assign_ids(state)
    state.objects = LIST.map(state.objects, funcref(OBJECT, "write_id_to_node")) # Side-effect
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_angular_velocity"))
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_linear_velocity"))
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_scale"))
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display")) # Side-effect
    #state.objects = LIST.map(state.objects, funcref(PHYSICS, "create_physical_object"))
    return state

static func simulate(state: Dictionary, delta: float, world: Node) -> Dictionary:
    state = DICTIONARY.update(state, "tick", state.tick + 1)
    state.objects = LIST.map1(state.objects, funcref(SHIP, "update"), delta)
    state.objects = BULLET.shoot_bullets(state.objects, world) # Side-effect
    state = OBJECT.assign_ids(state)
    state.objects = PHYSICS.simulate(state.objects, delta)
    state.objects = LIST.map(state.objects, funcref(WRAP, "wrap"))
    state.objects = LIST.map(state.objects, funcref(SOUND, "play_collision_sound")) # Side-effect
    state.objects = LIST.map(state.objects, funcref(BULLET, "delete_on_collide"))
    state.objects = LIST.map1(state.objects, funcref(BULLET, "delete_on_timer"), delta)
    state.objects = LIST.map1(state.objects, funcref(BULLET, "spawn_bullet_particles_on_destroy"), world) # Side-effect
    state.objects = LIST.map(state.objects, funcref(NODE, "queue_free")) # Side-effect
    state.objects = OBJECT.queue_free(state.objects)
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display"))
    return state
