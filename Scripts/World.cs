using Godot;
using static StateFunctions;

public class World : Node
{
    private Label label;
    private State current_state;

    public override void _Ready()
    {
        current_state = InitialState(GetChildren());
    }

    public override void _Process(float delta)
    {
        current_state = UpdateState(current_state, delta, this);
    }
}
