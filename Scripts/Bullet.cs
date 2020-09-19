using Godot;

public class Bullet : DataObject
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
