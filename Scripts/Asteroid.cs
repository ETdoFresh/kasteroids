using Godot;
using System.Collections.Generic;
using System.Linq;

public class Asteroid : DataObject
{
    public bool randomizeLinearVeloicty = true;
    public float minLinearVelocity = 20.0f;
    public float maxLinearVeloicty = 100.0f;
    public bool randomizeAngularVelocity = true;
    public float minAngularVelocity = -3.0f;
    public float maxAngularVeloicty = 3.0f;
    public bool randomizeScale = true;
    public float minScale = 0.75f;
    public float maxScale = 1.0f;
    public Vector2 linearVelocity = Vector2.Zero;
    public float angularVelocity = 0.0f;
}

public static class AsteroidFunctions
{
    public static State RandomizeAsteroids(this State state)
    {
        state = state.Duplicate();
        state.objects = state.objects
            .RemoveAsteroids()
            .Concat(state.objects
                .GetAsteroids()
                .Select(RandomizeLinearVelocity)
                .Select(RandomizeAngularVelocity)
                .Select(RandomizeScale));
        return state;
    }

    public static IEnumerable<DataObject> RemoveAsteroids(this IEnumerable<DataObject>objects)
        => objects.Where(o => !(o is Asteroid));
    
    public static IEnumerable<Asteroid> GetAsteroids(this IEnumerable<DataObject>objects)
        => objects.Where(o => o is Asteroid).Cast<Asteroid>();
    
    public static Asteroid RandomizeLinearVelocity(Asteroid asteroid)
    {
        if (!asteroid.randomizeLinearVeloicty) return asteroid;
        var minVel = asteroid.minLinearVelocity;
        var maxVel = asteroid.maxLinearVeloicty;
        asteroid.linearVelocity = Random.OnUnitCircle();
        asteroid.linearVelocity *= Random.RandfRange(minVel, maxVel);
        return asteroid;
    }

    public static Asteroid RandomizeAngularVelocity(Asteroid asteroid)
    {
        if (!asteroid.randomizeAngularVelocity) return asteroid;
        var minVel = asteroid.minAngularVelocity;
        var maxVel = asteroid.maxAngularVeloicty;
        asteroid.angularVelocity = Random.RandfRange(minVel, maxVel);
        return asteroid;
    }

    public static Asteroid RandomizeScale(Asteroid asteroid)
    {
        if (!asteroid.randomizeScale) return asteroid;
        var minScale = asteroid.minScale;
        var maxScale = asteroid.maxScale;
        asteroid.scale *= Random.RandfRange(minScale, maxScale);
        return asteroid;
    }
}
