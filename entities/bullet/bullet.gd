class_name Bullet
extends KinematicBody2D

var id = -1
var max_linear_velocity = 800 + 500
var linear_velocity = Vector2.ZERO
var angular_velocity = 0
var mass = 0.15
var bounce = 0.0
var ship_id = -1

func _ready():
    var _1 = $DestroyAfter.connect("timeout", self, "destroy")

func simulate(delta):
    if linear_velocity.length() > max_linear_velocity:
        linear_velocity = linear_velocity.normalized() * max_linear_velocity
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        bounce_collision(collision)
        destroy()
    
    $Wrap.wrap(self)

func bounce_collision(collision : KinematicCollision2D):
    Data.bounce(self, collision)

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
        "angular_velocity": angular_velocity,
        "ship_id": ship_id }

func from_dictionary(dictionary):
    if dictionary.has("id"): id = dictionary.id
    if dictionary.has("position"): global_position = dictionary.position
    if dictionary.has("rotation"): global_rotation = dictionary.rotation
    if dictionary.has("scale"): $CollisionShape2D.scale = dictionary.scale
    if dictionary.has("linear_velocity"): linear_velocity = dictionary.linear_velocity
    if dictionary.has("angular_velocity"): angular_velocity = dictionary.angular_velocity
    if dictionary.has("ship_id"): ship_id = dictionary.ship_id
