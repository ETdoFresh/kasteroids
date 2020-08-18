extends KinematicBody2D

export var engine_thrust = 500
export var spin_thrust = 10
export var max_speed = 500

var input = InputData.new()
var thrust = Vector2()
var rotation_dir = 0
var linear_velocity = Vector2.ZERO
var linear_acceleration = Vector2.ZERO
var angular_velocity = 0
var mass = 1

onready var gun = $Gun

func _process(_delta):
    thrust = Vector2(0, input.vertical * engine_thrust)
    rotation_dir = input.horizontal

func _physics_process(delta):
    linear_acceleration = thrust.rotated(global_rotation)
    linear_velocity += linear_acceleration * delta
    if linear_velocity.length() > max_speed:
        linear_velocity = linear_velocity.normalized() * max_speed
    
    angular_velocity = rotation_dir * spin_thrust * delta
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        bounce(collision)
    global_rotation += angular_velocity
    $Wrap.wrap(self)

func bounce(collision : KinematicCollision2D):
    var collider = collision.collider
    var ma = mass
    var mb = collider.mass
    var va = linear_velocity
    var vb = collider.linear_velocity
    var n = collision.normal
    var cr = 1.0 # Coefficient of Restitution
    var wa = angular_velocity
    var wb = collider.angular_velocity
    var ra = collision.position - position
    var rb = collision.position - collider.position
    var ia = ma * ra * ra # Rotational Inertia
    var ib = mb * rb * rb # Rotational Inertia
    var la = wa * ia # Angular Momementum
    var lb = wb * ib # Angular Momementum
    var raxn = ra.project(n)
    var rbxn = rb.project(n)
    var j = -(1.0 + cr) * ((va - vb).dot(n)) # Impulse Magnitude
    j /= (1.0/ma + 1.0/mb) + ((ia * raxn).project(ra) + (ib * rbxn).project(rb)).dot(n)
    linear_velocity = va + (j / ma) * n
    collider.linear_velocity = vb - (j / ma) * n
    #angular_velocity = wa + (ia * ra.project(j * n)).length()
    #collider.angular_velocity = wb - (ib * rb.project(j * n)).length()

func change_position(new_position):
    self.new_position = new_position

func _integrate_forces(state):
    ._integrate_forces(state)
    $Wrap.wrap(state)

func state_enter(previous_state):
    if previous_state is Node2D:
        position = previous_state.position
        rotation = previous_state.rotation
    else:
        position = Vector2(0,0)
        rotation = 0
    
    if previous_state is RigidBody2D:
        linear_velocity = previous_state.linear_velocity
        angular_velocity = previous_state.angular_velocity
    else:
        linear_velocity = Vector2(0,0)
        angular_velocity = 0
    
    $LabelNode2D.global_rotation = 0
