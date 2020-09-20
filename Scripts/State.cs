using System.Collections.Generic;

public class State
{
    public int tick;
    public int nextId;
    public float delta = 0;
    public IEnumerable<DataObject> objects;

    public State() {}
    
    public State(State clone)
        => new State{
            tick = clone.tick, 
            nextId = clone.nextId,
            objects = clone.objects, 
            delta = clone.delta};

    public State Duplicate() => new State(this);

    public State UpdateObjects(IEnumerable<DataObject> newObjects)
        => new State(this){objects = newObjects};

    public State UpdateTick(int newTick)
        => new State(this){tick = newTick};
    
    public State UpdateNextId(int newNextId)
        => new State(this){nextId = newNextId};
    
    public State UpdateDelta(float newDelta)
        => new State(this){delta = newDelta};

    public State IncrementTick() => UpdateTick(tick + 1);
}
