using Godot;

public static class ScenePath
{
    public const string ASTEROID = "res://scenes/asteroid/asteroid.tscn";
    public const string BULLET = "res://scenes/bullet/bullet.tscn";

    public static PackedScene Load(string path)
        => ResourceLoader.Load<PackedScene>(path);
}