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
        destroy()
    
    $Wrap.wrap(self)

func bounce(collision : KinematicCollision2D):
    var collider = collision.collider
    var ma = mass
    var mb = collider.mass
    var va = linear_velocity
    var vb = collider.linear_velocity
    var n = collision.normal
    var cr = 0.2 # Coefficient of Restitution
    var j = -(1.0 + cr) * ((va - vb).dot(n))
    j /= (1.0/ma + 1.0/mb)
    linear_velocity = va + (j / ma) * n
    collider.linear_velocity = vb - (j / ma) * n
    # If you need to consider more accuracy maybe?
    #var collision_velocity_ratio = 1
    #if va.length() > 0:
    #    collision_velocity_ratio = linear_velocity.length() / va.length()
    #position += linear_velocity.normalized() * collision.remainder.length() * collision_velocity_ratio
    print ("%s|%s: %s %s %s %s %s %s %s %s" % [name, collider.name, ma, mb, va, vb, n , cr ,j, linear_velocity])

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
