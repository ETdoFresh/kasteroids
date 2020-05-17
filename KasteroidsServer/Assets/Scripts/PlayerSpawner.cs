using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using UnityEngine;
using UnityEngine.Events;
using UnityNetworking;
using Object = UnityEngine.Object;

public class PlayerSpawner : MonoBehaviour
{
    public List<int> players = new List<int>();
    public List<GameObject> ships = new List<GameObject>();
    public List<Socket> sockets = new List<Socket>();
    public GameObject shipPrefab;
    public WorldState worldState;
    public TCPServerUnity server;

    private void OnValidate()
    {
        if (!worldState) worldState = FindObjectOfType<WorldState>();
        if (!server) server = FindObjectOfType<TCPServerUnity>();
    }

    private void OnEnable()
    {
        if (!server) return;
        FindObjectOfType<TCPServerUnity>().OnOpen.AddListener(OnPlayerEnter);
        FindObjectOfType<TCPServerUnity>().OnClose.AddListener(OnPlayerExit);
    }

    private void OnDisable()
    {
        if (!server) return;
        FindObjectOfType<TCPServerUnity>().OnOpen.RemoveListener(OnPlayerEnter);
        FindObjectOfType<TCPServerUnity>().OnClose.RemoveListener(OnPlayerExit);
    }

    private void OnPlayerEnter(Object arg0, Socket socket)
    {
        var id = 0;
        for (id = 1; id <= ships.Count + 1; id++)
            if (!players.Contains(id))
                break;
        players.Add(id);
        var ship = Instantiate(shipPrefab);
        ship.GetComponent<ShipControls>().SetId(id);
        ships.Add(ship);
        sockets.Add(socket);
    }

    private void OnPlayerExit(Object arg0, Socket socket)
    {
        var i = sockets.IndexOf(socket);
        if (i < 0) return;
        players.RemoveAt(i);
        Destroy(ships[i]);
        ships.RemoveAt(i);
        sockets.RemoveAt(i);
    }

    private void FixedUpdate()
    {
        if (!server) return;
        for (var i = 0; i < sockets.Count; i++)
            server.Send(sockets[i], worldState.Serialize(players[i]));
    }
}