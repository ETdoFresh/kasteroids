using Godot;

public static class Random
{
    public static float RandfRange(float from, float to)
        => (float)GD.RandRange(from, to);
    
    public static int RandiRange(int from, int to)
        => (int)GD.Randi() % (from - to) + from;
    
    public static Vector2 InsideUnitCircle()
    {
        var randomRadius = RandfRange(0, 1);
        return OnUnitCircle() * randomRadius;
    }

    public static Vector2 OnUnitCircle()
    {
        var randomAngle = RandfRange(0, 2 * Mathf.Pi);
        return new Vector2(Mathf.Cos(randomAngle), Mathf.Sin(randomAngle));
    }
}