public static class StateFunctions
{
    public static State EmptyState
        => new State {tick = 0, nextId = 1, objects = new DataObject[0] };

    public static State InitialState(Godot.Collections.Array children)
    {
        return EmptyState
            .AddObjectsFromScene(children)
            .RandomizeAsteroids()
            .UpdateSprites();
    }

    public static State UpdateState(State state, float delta)
    {
        return state
            .IncrementTick()
            .UpdateDelta(delta)
            .ApplyShipInputs()
            .CreateObjects()
            .SetCooldowns()
            .SimulatePhysics()
            .WrapAroundScreen()
            .PlayCollisionSounds()
            .DeleteOnCollide()
            .DeleteAfterDuration()
            .SpawnParticles()
            .DeleteObjects()
            .UpdateSprites();
    }
}
