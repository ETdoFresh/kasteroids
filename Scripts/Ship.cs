using Godot;

public class Ship : Node2D
{
    public Position position;
    public Rotation rotation;
    public Scale scale;
    [Export] public LinearVelocity linearVelocity;
    public AngularVelocity angularVelocity;
    public Mass mass;
    public BounceCoeff bounceCoeff;
    public Cooldown cooldown;

    public object[] Components()
    {
        return new object[]{
            position, rotation, scale, linearVelocity, 
            angularVelocity, mass, bounceCoeff, cooldown};
    }
}