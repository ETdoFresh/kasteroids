using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldState : CustomMonoBehaviour
{
    public List<Ship> ships = new List<Ship>();
    public List<Asteroid> asteroids = new List<Asteroid>();
    public List<Bullet> bullets = new List<Bullet>();

    public GameObject shipPrefab;
    public GameObject asteroidPrefab;
    public GameObject bulletPrefab;
    public Player player;

    public string Serialize(int clientId)
    {
        return $"{clientId},{Serialize()}";
    }
    
    public string Serialize()
    {
        var output = "";
        output += $"{ships.Count},";
        foreach (var ship in ships)
        {
            var shipTransform = ship.transform;
            var shipPosition = shipTransform.position;
            var shipEulerAngles = shipTransform.eulerAngles;
            var shipScale = shipTransform.localScale;
            var shipName = ship.playerNickname.value.Replace(",","");
            output += $"{shipPosition.x},";
            output += $"{shipPosition.y},";
            output += $"{shipEulerAngles.z},";
            output += $"{shipScale.x},";
            output += $"{shipScale.y},";
            output += $"{shipName},";
        }
        output += $"{asteroids.Count},";
        foreach (var asteroid in asteroids)
        {
            var asteroidTransform = asteroid.transform;
            var asteroidPosition = asteroidTransform.position;
            var asteroidEulerAngles = asteroidTransform.eulerAngles;
            var asteroidScale = asteroidTransform.localScale;
            output += $"{asteroidPosition.x},";
            output += $"{asteroidPosition.y},";
            output += $"{asteroidEulerAngles.z},";
            output += $"{asteroidScale.x},";
            output += $"{asteroidScale.y},";
        }
        output += $"{bullets.Count},";
        foreach (var bullet in bullets)
        {
            var bulletTransform = bullet.transform;
            var bulletPosition = bulletTransform.position;
            var bulletEulerAngles = bulletTransform.eulerAngles;
            var bulletScale = bulletTransform.localScale;
            output += $"{bulletPosition.x},";
            output += $"{bulletPosition.y},";
            output += $"{bulletEulerAngles.z},";
            output += $"{bulletScale.x},";
            output += $"{bulletScale.y},";
        }

        return output;
    }

    public void Deserialize(string serialized)
    {
        var items = serialized.Split(',');

        if (player) player.id.value = Convert.ToInt32(items[0]);
        
        var x = 1;
        try
        {
            var shipCount = int.Parse(items[x++]);

            // Destroy Missing Ships
            for (var i = ships.Count - 1; i >= shipCount; i--)
            {
                Destroy(ships[i].gameObject);
                ships.RemoveAt(i);
            }

            // Add New Ships
            for (var i = ships.Count; i < shipCount; i++)
                ships.Add(Instantiate(shipPrefab).GetComponent<Ship>());

            // Update Ships
            for (var i = 0; i < ships.Count; i++)
            {
                var positionX = float.Parse(items[x++]);
                var positionY = float.Parse(items[x++]);
                var rotationZ = float.Parse(items[x++]);
                var scaleX = float.Parse(items[x++]);
                var scaleY = float.Parse(items[x++]);
                var shipNickName = items[x++];
                ships[i].transform.position = new Vector3(positionX, positionY, 0);
                ships[i].transform.eulerAngles = new Vector3(0, 0, rotationZ);
                ships[i].transform.localScale = new Vector3(scaleX, scaleY, 1);
                ships[i].playerNickname.value = shipNickName;
            }

            var asteroidCount = int.Parse(items[x++]);

            // Destroy Missing Asteroids
            for (var i = asteroids.Count - 1; i >= asteroidCount; i--)
            {
                Destroy(asteroids[i].gameObject);
                asteroids.RemoveAt(i);
            }

            // Add New Asteroids
            for (var i = asteroids.Count; i < asteroidCount; i++)
                asteroids.Add(Instantiate(asteroidPrefab).GetComponent<Asteroid>());

            // Update Asteroids
            for (var i = 0; i < asteroids.Count; i++)
            {
                var positionX = float.Parse(items[x++]);
                var positionY = float.Parse(items[x++]);
                var rotationZ = float.Parse(items[x++]);
                var scaleX = float.Parse(items[x++]);
                var scaleY = float.Parse(items[x++]);
                asteroids[i].transform.position = new Vector3(positionX, positionY, 0);
                asteroids[i].transform.eulerAngles = new Vector3(0, 0, rotationZ);
                asteroids[i].transform.localScale = new Vector3(scaleX, scaleY, 1);
            }

            var bulletCount = int.Parse(items[x++]);

            // Destroy Missing Bullets
            for (var i = bullets.Count - 1; i >= bulletCount; i--)
            {
                Destroy(bullets[i].gameObject);
                bullets.RemoveAt(i);
            }

            // Add New Bullets
            for (var i = bullets.Count; i < bulletCount; i++)
                bullets.Add(Instantiate(bulletPrefab).GetComponent<Bullet>());

            // Update Bullets
            for (var i = 0; i < bullets.Count; i++)
            {
                var positionX = float.Parse(items[x++]);
                var positionY = float.Parse(items[x++]);
                var rotationZ = float.Parse(items[x++]);
                var scaleX = float.Parse(items[x++]);
                var scaleY = float.Parse(items[x++]);
                bullets[i].transform.position = new Vector3(positionX, positionY, 0);
                bullets[i].transform.eulerAngles = new Vector3(0, 0, rotationZ);
                bullets[i].transform.localScale = new Vector3(scaleX, scaleY, 1);
            }
        }
        catch (Exception ex)
        {
            Debug.LogWarning(serialized + "\n" + ex.Message);
        }
    }
}
