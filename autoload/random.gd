extends Node

var random = RandomNumberGenerator.new()

func _ready():
    random.randomize()

func randf_range(from: float, to: float) -> float:
    return random.randf_range(from, to)

func randi_range(from: int, to: int) -> int:
    return random.randi_range(from, to)

func inside_unit_circle() -> Vector2:
    var random_radius = randf_range(0,1)
    return on_unit_circle() * random_radius

func on_unit_circle() -> Vector2:
    var random_angle = randf_range(0, 2 * PI)
    return Vector2(cos(random_angle), sin(random_angle))
