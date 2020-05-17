using System;

namespace KasteroidsShared
{
    public class Position
    {
        public Vector2 value;
    }

    public class Rotation
    {
        public float value;
    }

    public class Scale
    {
        public Vector2 value = Vector2.One;
    }

    public class Speed
    {
        public float value;
    }

    public class TurnSpeed
    {
        public float value;
    }

    public class Ship
    {
        public Position position;
        public Rotation Rotation;
        public Scale scale;
        public Speed speed;
        public TurnSpeed turnSpeed;
    }

    public class Asteroid
    {
        public Position position;
        public Rotation rotation;
        public Scale scale;
        public Speed speed;
        public TurnSpeed turnSpeed;
    }

    public class Bullet
    {
        public Position position;
        public Scale scale;
        public Speed speed;
    }

    public class State
    {
        public Ship[] ships;
        public Asteroid[] asteroids;
        public Bullet[] bullets;
    }

    public class Vector2
    {
        public static readonly Vector2 Zero = new Vector2();
        public static readonly Vector2 One = new Vector2 {x = 1, y = 1};

        public float x;
        public float y;
    }

    public class Color
    {
        public static readonly Color Red = new Color {r = 1};
        public static readonly Color Black = new Color();

        public float r;
        public float g;
        public float b;
        public float a = 1;
    }
}