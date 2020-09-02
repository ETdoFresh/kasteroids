class_name Asteroid
extends KinematicBody2D

export var enabled = true
export var min_angular_velocity = -3.0
export var max_angular_velocity = 3.0
export var min_linear_velocity = 20.0
export var max_linear_velocity = 100.0
export var min_scale = 0.75
export var max_scale = 1.0

var random = RandomNumberGenerator.new()
var id = -1
var linear_velocity = Vector2.ZERO
var angular_velocity = 0
var mass = 5.0
var bounce = 0.0
var history = {}

func _ready():
    if not enabled:
        queue_free()
    else:
        random.randomize()
        randomize_spin()
        randomize_speed()
        randomize_scale()

func simulate(delta):
    if linear_velocity.length() > max_linear_velocity * 10:
        linear_velocity = linear_velocity.normalized() * max_linear_velocity * 10
    
    if abs(angular_velocity) > max_angular_velocity:
        angular_velocity = sign(angular_velocity) * max_angular_velocity
    
    var collision = move_and_collide(linear_velocity * delta)
    if collision:
        $CollisionSound.play_sound()
        bounce_collision(collision)
    global_rotation += angular_velocity * delta
    $Wrap.wrap(self)

func bounce_collision(collision : KinematicCollision2D):
    Data.bounce(self, collision)

func randomize_spin():
    angular_velocity = random.randf_range(min_angular_velocity, max_angular_velocity)

func randomize_speed():
    var random_direction = Vector2(1,0).rotated(random.randf() * 2 * PI)
    linear_velocity = random_direction
    linear_velocity *= random.randf_range(min_linear_velocity, max_linear_velocity)

func randomize_scale():
    $CollisionShape2D.scale *= random.randf_range(min_scale, max_scale)

func to_dictionary():
    return {
        "id": id,
        "type": "Asteroid",
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

func record(tick):
    history[tick] = to_dictionary()

func rewind(tick):
    if history.has(tick):
        from_dictionary(history[tick])

func erase_history(tick):
    for history_tick in history.keys():
        if history_tick < tick:
            history.erase(history_tick)
