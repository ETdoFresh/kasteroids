class_name StateFunctions

const ASTEROID = AsteroidFunctions
const ID = IdFunctions
const DICTIONARY = DictionaryFunctions
const LIST = ListFunctions
const NODE = NodeFunctions
const PHYSICS = PhysicsFunctions
const SHIP = ShipFunctions
const SOUND = SoundFunctions
const WRAP = WrapFunctions

static func empty_state() -> Dictionary:
    return {"tick": 0, "objects": []}

static func initial_state(children: Array):
    var state = empty_state()
    state.objects = LIST.map(children, funcref(NODE, "to_dictionary"))
    state.objects = ID.assign_ids(state.objects)
    state.objects = LIST.map(state.objects, funcref(ID, "write_id_to_node")) # Side-effect
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_angular_velocity"))
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_linear_velocity"))
    state.objects = LIST.map(state.objects, funcref(ASTEROID, "randomize_scale"))
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display")) # Side-effect
    #state.objects = LIST.map(state.objects, funcref(PHYSICS, "create_physical_object"))
    return state

static func simulate(state : Dictionary, delta : float) -> Dictionary:
    state = DICTIONARY.update(state, "tick", state.tick + 1)
    state.objects = LIST.map1(state.objects, funcref(SHIP, "apply_input"), delta)
    #state.objects = LIST.map(state.objects, funcref(BULLET, "create_bullets")) # Side-effect
    state.objects = LIST.map(state.objects, funcref(SHIP, "limit_speed"))
    state.objects = PHYSICS.simulate(state.objects, delta)
    state.objects = LIST.map(state.objects, funcref(WRAP, "wrap"))
    state.objects = LIST.map(state.objects, funcref(SOUND, "play_collision_sound")) # Side-effect
    #state.objects = LIST.map(state.objects, funcref(BULLET, "delete_bullets")) # Side-effect
    state.objects = LIST.map(state.objects, funcref(NODE, "update_display"))
    return state
