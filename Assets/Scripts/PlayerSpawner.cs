using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using UnityEngine;

public class PlayerSpawner : CustomMonoBehaviour
{
    public PriorityQueue<int> availableIds = new PriorityQueue<int>(1, 2, 3, 4, 5, 6, 7, 8);

    public List<Socket> sockets = new List<Socket>();
    public List<Client> clients = new List<Client>();
    public GameObject shipPrefab;

    public Client Spawn(Socket socket)
    {
        var id = availableIds.Dequeue();
        var playerInput = FindObjectsOfType<PlayerInput>()
            .Where(p => p.gameObject.scene == gameObject.scene)
            .FirstOrDefault(p => p.id == id);

        var ship = Instantiate(shipPrefab).GetComponent<Ship>();
        ship.playerInput = playerInput;

        var client = new Client {socket = socket, ship = ship, id = id};
        sockets.Add(socket);
        clients.Add(client);
        return client;
    }

    public void Despawn(Socket socket)
    {
        var i = sockets.IndexOf(socket);
        var client = clients[i];
        availableIds.Enqueue(client.id);
        Destroy(client.ship.gameObject);

        sockets.RemoveAt(i);
        clients.RemoveAt(i);
    }

    [Serializable]
    public class Client
    {
        public Socket socket;
        public Ship ship;
        public int id;
    }
}