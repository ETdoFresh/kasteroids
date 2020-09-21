using System.Linq;
using Godot;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;
using IShips = System.Collections.Generic.IEnumerable<Ship>;

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
    public AudioStreamPlayer spawnSound;
    public float destroyTimer = 0f;
    public float destroyTime = 1f;
}

public static class BulletFunctions
{
    public static IObjects AddNewBulletsToObjects(this IShips ships, Node world)
    {
        return ships.Select(ship => CreateShipBullet(ship, world));
    }

    public static Bullet CreateShipBullet(Ship ship, Node world)
    {
        var bullet = new Bullet();
        var node = (Node2D)ScenePath.Load(ScenePath.BULLET).Instance();
        bullet.node = node;
        world.AddChild(bullet.node);
        bullet.spawnSound = node.Get<AudioStreamPlayer>("SpawnSound");
        bullet.position = ship.gun.GlobalPosition;
        bullet.rotation = ship.gun.GlobalRotation;
        node.GlobalPosition = bullet.position;
        node.GlobalRotation = bullet.rotation;
        bullet.linearVelocity = new Vector2(0, -800).Rotated(ship.gun.GlobalRotation);
        bullet.linearVelocity += ship.linearVelocity;
        bullet.spawnSound.Play();
        return bullet;
    }
}