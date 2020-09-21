using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;
using IShips = System.Collections.Generic.IEnumerable<Ship>;

public class ShipNode : Node2D
{
    public Ship ship = new Ship();

    public override void _Ready()
    {
        ship.input.node = GetNode("Input");
        ship.gun = GetNode<Node2D>("Gun");
    }
}

public class Ship : DataObject
{
    public float speed = 800;
    public float spin = 10;
    public Vector2 linearVelocity = Vector2.Zero;
    public float angularVelocity = 0.0f;
    public InputData input = new InputData();
    public float cooldown = 0.2f;
    public float cooldownTimer = 0f;
    public Node2D gun;
}

public static class ShipFunctions
{
    public static IObjects ApplyInputs(this IObjects objects, float delta)
    {
        return objects
            .ApplyOn<Ship>(ship => ApplyInput(ship, delta));
    }

    public static Ship ApplyInput(Ship ship, float delta)
    {
        ship.input.GetValues();
        var thrust = new Vector2(0, ship.input.vertical * ship.speed);
        var linearAcceleration = thrust.Rotated(ship.rotation);
        ship.linearVelocity += linearAcceleration * delta;
        var rotationDir = ship.input.horizontal;
        ship.angularVelocity = rotationDir * ship.spin * delta;
        return ship;
    }

    public static IShips GetIsReadyToFire(this IShips ships)
        => ships.Where(IsReadyToFire);
    
    public static IShips GetIsFiring(this IShips ships)
        => ships.Where(IsFiring);

    private static bool IsReadyToFire(Ship ship)
        => ship.cooldownTimer <= 0;
    
    private static bool IsFiring(Ship ship)
        => ship.input.fire;
}