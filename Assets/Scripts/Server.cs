using System;
using System.Collections.Generic;
using System.Net.Sockets;
using CSharpNetworking;
using UnityEngine;
using UnityNetworking;
using Object = UnityEngine.Object;

public class Server : MonoBehaviour
{
    public TCPServerUnity server;
    public WorldState worldState;
    public PlayerSpawner playerSpawner;
    
    private void OnValidate()
    {
        if (!server) server = GetComponent<TCPServerUnity>();
    }

    private void OnEnable()
    {
#if UNITY_EDITOR
        UnityEditor.Events.UnityEventTools.AddPersistentListener(server.OnMessage, OnMessage);
        UnityEditor.Events.UnityEventTools.AddPersistentListener(server.OnOpen, OnOpen);
        UnityEditor.Events.UnityEventTools.AddPersistentListener(server.OnClose, OnClose);
#else
        server.OnMessage.AddListener(OnMessage);
        server.OnOpen.AddListener(OnOpen);
        server.OnClose.AddListener(OnClose);
#endif
    }

    private void OnOpen(Object tcpServer, Socket socket)
    {
        Debug.Log("Client Connected");
        playerSpawner.Spawn(socket);
    }

    private void OnClose(Object tcpServer, Socket socket)
    {
        Debug.Log("Client Disconnected");
        playerSpawner.Despawn(socket);
    }

    private void OnMessage(Object tcpServer, Message<Socket> message)
    {
        //Debug.Log(message.data);
        foreach(var playerInput in FindObjectsOfType<PlayerInput>())
            if (gameObject.scene == playerInput.gameObject.scene)
                playerInput.Deserialize(message.data);
    }

    private void FixedUpdate()
    {
        foreach (var client in playerSpawner.clients)
            server.Send(client.socket, worldState.Serialize(client.id));
    }
}