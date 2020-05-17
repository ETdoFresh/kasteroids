using System;
using System.Collections.Generic;
using UnityEngine;

public class WorldState : MonoBehaviour
{
    public List<Ship> ships = new List<Ship>();
    public List<Asteroid> asteroids = new List<Asteroid>();
    public List<Bullet> bullets = new List<Bullet>();

    public string Serialize(int playerId)
    {
        return $"{playerId},{Serialize()}";
    }
    
    public string Serialize()
    {
        var output = "";
        output += $"{ships.Count},";
        foreach (var ship in ships)
        {
            output += $"{ship.transform.position.x},";
            output += $"{ship.transform.position.y},";
            output += $"{ship.transform.eulerAngles.z},";
            output += $"{ship.transform.localScale.x},";
            output += $"{ship.transform.localScale.y},";
        }
        output += $"{asteroids.Count},";
        foreach (var asteroid in asteroids)
        {
            output += $"{asteroid.transform.position.x},";
            output += $"{asteroid.transform.position.y},";
            output += $"{asteroid.transform.eulerAngles.z},";
            output += $"{asteroid.transform.localScale.x},";
            output += $"{asteroid.transform.localScale.y},";
        }
        output += $"{bullets.Count},";
        foreach (var bullet in bullets)
        {
            output += $"{bullet.transform.position.x},";
            output += $"{bullet.transform.position.y},";
            output += $"{bullet.transform.localScale.x},";
            output += $"{bullet.transform.localScale.y},";
        }

        return output;
    }

    public byte[] SerializeBytes()
    {
        var output = new List<byte>();
        output.AddRange(BitConverter.GetBytes(ships.Count));
        foreach (var ship in ships)
        {
            var t = ship.transform;
            var position = t.position;
            var eulerAngles = t.eulerAngles;
            var scale = t.localScale;
            output.AddRange(BitConverter.GetBytes(position.x));
            output.AddRange(BitConverter.GetBytes(position.y));
            output.AddRange(BitConverter.GetBytes(eulerAngles.z));
            output.AddRange(BitConverter.GetBytes(scale.x));
            output.AddRange(BitConverter.GetBytes(scale.y));
        }
        output.AddRange(BitConverter.GetBytes(asteroids.Count));
        foreach (var asteroid in asteroids)
        {
            var t = asteroid.transform;
            var position = t.position;
            var eulerAngles = t.eulerAngles;
            var scale = t.localScale;
            output.AddRange(BitConverter.GetBytes(position.x));
            output.AddRange(BitConverter.GetBytes(position.y));
            output.AddRange(BitConverter.GetBytes(eulerAngles.z));
            output.AddRange(BitConverter.GetBytes(scale.x));
            output.AddRange(BitConverter.GetBytes(scale.y));
        }
        output.AddRange(BitConverter.GetBytes(bullets.Count));
        foreach (var bullet in bullets)
        {
            var t = bullet.transform;
            var position = t.position;
            var scale = t.localScale;
            output.AddRange(BitConverter.GetBytes(position.x));
            output.AddRange(BitConverter.GetBytes(position.y));
            output.AddRange(BitConverter.GetBytes(scale.x));
            output.AddRange(BitConverter.GetBytes(scale.y));
        }

        return output.ToArray();
    }
}