using System;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;

public class State
{
    public int tick;
    public int nextId;
    public IObjects objects;

    public State() { }

    public State(State clone)
    {
        tick = clone.tick;
        nextId = clone.nextId;
        objects = clone.objects;
    }

    public State Duplicate() => new State(this);

    public State UpdateObjects(Func<IObjects, IObjects> func)
        => new State(this) { objects = func(this.objects) };

    public State UpdateTick(Func<int, int> func)
        => new State(this) { tick = func(tick) };

    public State UpdateNextId(int newNextId)
        => new State(this) { nextId = newNextId };

    public State IncrementTick() => UpdateTick(AddOne);

    private int AddOne(int i) => i + 1;
}
