using Godot;
using System.Linq;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;

public static class StateFunctions
{
    public static State EmptyState
        => new State {tick = 0, nextId = 1, objects = new DataObject[0] };

    public static State InitialState(Godot.Collections.Array children)
    {
        return EmptyState
            .UpdateObjects(objects => objects
                .AddObjectsFromScene(children)
                .RandomizeAsteroids()
                .UpdateSprites()); // Side-effect
    }

    public static State UpdateState(State state, float delta, Node world)
    {
        return state
            .IncrementTick()
            .UpdateObjects(objects => objects
                .ApplyInputs(delta)
                .SimulateGame(delta, world))
            .RecordHistory();
    }

    public static IObjects SimulateGame(this IObjects objects, float delta, Node world)
    {
        return objects
            .CreateBullets(world)
            .SetCooldowns()
            .SimulatePhysics(delta)
            .WrapAroundScreen()
            .PlayCollisionSounds()
            .DeleteOnCollide()
            .DeleteAfterDuration(delta)
            .SpawnParticles()
            .DeleteObjects()
            .UpdateSprites();
    }

    public static State RecordHistory(this State state)
    {
        return state;
    }

    public static IObjects CreateBullets(this IObjects objects, Node world)
    {
        return objects
            .Concat(objects
                .Get<Ship>()
                .GetIsReadyToFire()
                .GetIsFiring()
                .AddNewBulletsToObjects(world));
    }

    public static IObjects SetCooldowns(this IObjects objects)
    {
        return objects;
    }

    public static IObjects SimulatePhysics(this IObjects objects, float delta)
    {
        return objects;
    }

    public static IObjects WrapAroundScreen(this IObjects objects)
    {
        return objects;
    }
    public static IObjects PlayCollisionSounds(this IObjects objects)
    {
        return objects;
    }
    public static IObjects DeleteOnCollide(this IObjects objects)
    {
        return objects;
    }
    public static IObjects DeleteAfterDuration(this IObjects objects, float delta)
    {
        return objects;
    }
    public static IObjects SpawnParticles(this IObjects objects)
    {
        return objects;
    }
    public static IObjects DeleteObjects(this IObjects objects)
    {
        return objects;
    }
}
