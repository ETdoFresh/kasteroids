using System.Collections.Generic;

public class State
{
    public int tick;
    public int next_id;
    public IEnumerable<DataObject> objects;

    public State Duplicate()
    {
        return new State{tick = tick, next_id = next_id, objects = objects};
    }
}
