class_name Bullet
extends KinematicBody2D

var id = -1
var max_linear_velocity = 800
var linear_velocity = Vector2.ZERO
var angular_velocity = 0
var mass = 0.15

func _ready():
    var _1 = $DestroyAfter.connect("timeout", self, "destroy")

func start(position, rotation, rigidbody, velocity_magnitude):
    global_position = position
    global_rotation = rotation
    add_collision_exception_with(rigidbody)
    
    var ship_velocity = rigidbody.linear_velocity
    linear_velocity = ship_velocity + Vector2(0, -velocity_magnitude).rotated(rotation)

func _physics_process(delta):
    if linear_velocity.length() > max_linear_velocity:
        linear_velocity = linear_velocity.normalized() * max_linear_velocity
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        bounce(collision)
        #destroy()
    
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
    j /= (1.0/ma + 1.0/mb) #+ ((ia * raxn).project(ra) + (ib * rbxn).project(rb)).dot(n)
    linear_velocity = va + (j / ma) * n
    collider.linear_velocity = vb - (j / ma) * n
    #angular_velocity = wa + (ia * ra.project(j * n)).length()
    #collider.angular_velocity = wb - (ib * rb.project(j * n)).length()

func destroy():
    var bullet_particles = Scene.BULLET_PARTICLES.instance()
    var container = get_parent()
    var world = container.get_parent()
    world.add_child(bullet_particles)
    bullet_particles.position = global_position
    bullet_particles.emitting = true
    queue_free()

func to_dictionary():
    return {
        "id": id,
        "type": "Bullet",
        "position": global_position,
        "rotation": global_rotation,
        "scale": $CollisionShape2D.scale,
        "linear_velocity": linear_velocity,
        "angular_velocity": angular_velocity }

func from_dictionary(dictionary):
    if dictionary.has("id"): id = dictionary.id
    if dictionary.has("position"): global_position = dictionary.position
    if dictionary.has("rotation"): global_rotation = dictionary.rotation
    if dictionary.has("scale"): $CollisionShape2D.scale = dictionary.scale
    if dictionary.has("linear_velocity"): linear_velocity = dictionary.linear_velocity
    if dictionary.has("angular_velocity"): angular_velocity = dictionary.angular_velocity
