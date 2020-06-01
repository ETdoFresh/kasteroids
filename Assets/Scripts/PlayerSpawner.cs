using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using UnityEngine;
using Random = UnityEngine.Random;

public class PlayerSpawner : CustomMonoBehaviour
{
    public PriorityQueue<int> availableIds = new PriorityQueue<int>(1, 2, 3, 4, 5, 6, 7, 8);

    public List<Socket> sockets = new List<Socket>();
    public List<Player> players = new List<Player>();
    public GameObject shipPrefab;

    public Player Spawn(Socket socket)
    {
        var id = availableIds.Dequeue();
        var playerInput = FindObjectsOfType<PlayerInput>()
            .Where(p => p.gameObject.scene == gameObject.scene)
            .FirstOrDefault(p => !p.player);

        var playerGameObject = new GameObject($"Player {id}");
        var player = playerGameObject.AddComponent<Player>();
        player.id = Id.AddComponent(playerGameObject, id);

        var nickname = "Guest";
        for (var i = 0; i < 1000; i++)
        {
            nickname = $"Guest{Random.Range(0, 1000):000}";
            var nameExists = false;
            foreach(var otherPlayer in this.FindObjectsOfTypeInScene<Player>())
                if (otherPlayer != player)
                    if (otherPlayer.nickname.value == nickname)
                    {
                        nameExists = true;
                        break;
                    }
            if (!nameExists)
                break;
        }
        player.nickname = Nickname.AddComponent(playerGameObject, nickname);
        
        player.socket = socket;
        player.ship = Instantiate(shipPrefab).GetComponent<Ship>();
        player.input = playerInput;
        
        player.ship.playerInput = player.input;
        player.ship.playerNickname = player.nickname;
        playerInput.player = player;
        
        sockets.Add(socket);
        players.Add(player);
        return player;
    }

    public void Despawn(Socket socket)
    {
        var i = sockets.IndexOf(socket);
        var player = players[i];
        availableIds.Enqueue(player.id.value);
        Destroy(player.ship.gameObject);
        Destroy(player.gameObject);

        sockets.RemoveAt(i);
        players.RemoveAt(i);
    }

    [Serializable]
    public class Client
    {
        public Socket socket;
        public Ship ship;
        public int id;
    }
}