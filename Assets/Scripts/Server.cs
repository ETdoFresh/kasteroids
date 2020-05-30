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
    public PlayerInput input;
    public WorldState worldState;

    public List<Socket> clients = new List<Socket>();

    private void OnValidate()
    {
        if (!server) server = GetComponent<TCPServerUnity>();
        if (!input) input = GetComponent<PlayerInput>();
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
        clients.Add(socket);
    }

    private void OnClose(Object tcpServer, Socket socket)
    {
        Debug.Log("Client Disconnected");
        clients.Remove(socket);
    }

    private void OnMessage(Object tcpServer, Message<Socket> message)
    {
        Debug.Log(message.data);
        input.Deserialize(message.data);
    }

    private void FixedUpdate()
    {
        foreach (var client in clients)
            server.Send(client, worldState.Serialize());
    }
}