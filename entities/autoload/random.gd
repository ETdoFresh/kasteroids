extends Node

var random = RandomNumberGenerator.new()

func _ready():
    random.randomize()

func randf(): return random.randf()
func randf_range(from, to): return random.randf_range(from, to)

func on_unit_circle():
    var random_direction = randf() * 2 * PI
    var x = cos(random_direction)
    var y = sin(random_direction)
    return Vector2(x, y)

func inside_unit_circle():
    var random_length = randf()
    return on_unit_circle() * random_length
