class_name Ship
extends KinematicBody2D

signal bullet_created(bullet)

var id = -1
var username = ""
var input = InputData.new()
var thrust = Vector2()
var rotation_dir = 0
var linear_velocity = Vector2.ZERO
var linear_acceleration = Vector2.ZERO
var angular_velocity = 0
var mass = 1.0
var bounce = 0.0

onready var state_machine = $States
onready var gun = $Gun

func _ready():
    gun.connect("bullet_created", self, "create_bullet")

func _process(_delta):
    $Name.position = state_machine.active_state.position
    $Name/Label.text = username

func simulate(delta):
    var state = get_active_state()
    var engine_thrust = state.engine_thrust if state && "engine_thrust" in state else 0
    var max_speed = state.max_speed if state && "max_speed" in state else 0
    var spin_thrust = state.spin_thrust if state && "spin_thrust" in state else 0
    thrust = Vector2(0, input.vertical * engine_thrust)
    rotation_dir = input.horizontal
    linear_acceleration = thrust.rotated(global_rotation)
    linear_velocity += linear_acceleration * delta
    if linear_velocity.length() > max_speed:
        linear_velocity = linear_velocity.normalized() * max_speed
    
    angular_velocity = rotation_dir * spin_thrust * delta
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        bounce_collision(collision)
    global_rotation += angular_velocity
    $Wrap.wrap(self)
    
    if input.fire:
        if gun.is_ready:
            gun.fire()
    
    $Name.global_rotation = 0

func bounce_collision(collision : KinematicCollision2D):
    var collider = collision.collider
    var ma = mass
    var mb = collider.mass
    var va = linear_velocity
    var vb = collider.linear_velocity
    var n = collision.normal
    var cr = bounce # Coefficient of Restitution
    var j = -(1.0 + cr) * (va - vb).dot(n) # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb)
    linear_velocity = va + (j / ma) * n
    collider.linear_velocity = vb - (j /mb) * n

func create_bullet(bullet):
    bullet.ship = self
    bullet.ship_id = id
    bullet.add_collision_exception_with(self)
    var relative_velocity = linear_velocity
    bullet.linear_velocity += relative_velocity
    emit_signal("bullet_created", bullet)

func state_name():
    return state_machine.active_state_name

func update_input(update_input):
    input = update_input
    username = input.username if "username" in input else username

func to_dictionary():
    return {
        "id": id,
        "type": "Ship",
        "position": global_position,
        "rotation": global_rotation,
        "scale": $CollisionShape2D.scale,
        "linear_velocity": linear_velocity,
        "angular_velocity": angular_velocity,
        "username": username }

func from_dictionary(dictionary):
    if dictionary.has("id"): id = dictionary["id"]
    if dictionary.has("username"): username = dictionary["username"]
    if dictionary.has("position"): global_position = dictionary["position"]
    if dictionary.has("rotation"): global_rotation = dictionary["rotation"]
    if dictionary.has("scale"): $CollisionShape2D.scale = dictionary["scale"]
    if dictionary.has("linear_velocity"): linear_velocity = dictionary["linear_velocity"]
    if dictionary.has("angular_velocity"): angular_velocity = dictionary["angular_velocity"]

func get_active_state():
    if state_machine and state_machine.active_state:
        return state_machine.active_state
    else:
        return null
