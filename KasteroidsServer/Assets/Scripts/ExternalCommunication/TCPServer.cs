using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using CSharpNetworking;
using UnityEngine;
using UnityNetworking;
using Object = UnityEngine.Object;

public class TCPServer : MonoBehaviour
{
    public List<Socket> clients = new List<Socket>();
    public WorldState state;
    public TCPServerUnity server;

    void Awake()
    {
        server.OnServerOpen.AddListener(OnServerOpen);
        server.OnServerClose.AddListener(OnServerClose);
        server.OnOpen.AddListener(OnOpen);
        server.OnMessage.AddListener(OnMessage);
        server.OnClose.AddListener(OnClose);
    }

    private void OnDestroy()
    {
        server.OnServerOpen.RemoveListener(OnServerOpen);
        server.OnServerClose.RemoveListener(OnServerClose);
        server.OnOpen.RemoveListener(OnOpen);
        server.OnMessage.RemoveListener(OnMessage);
        server.OnClose.RemoveListener(OnClose);
    }

    private void OnServerOpen(Object arg0)
    {
        Debug.Log("Server: Listening...");
    }

    private void OnServerClose(Object arg0)
    {
        Debug.Log("Server: Stop Listening...");
    }

    private void OnOpen(Object arg0, Socket arg1)
    {
        var ip = ((IPEndPoint) arg1.RemoteEndPoint).Address;
        var port = ((IPEndPoint) arg1.RemoteEndPoint).Port;
        Debug.Log($"Server: Client {ip}:{port} connected!");
    }

    private void OnMessage(Object arg0, Message<Socket> arg1)
    {
        // var ip = ((IPEndPoint) arg1.client.RemoteEndPoint).Address;
        // var port = ((IPEndPoint) arg1.client.RemoteEndPoint).Port;
        // Debug.Log($"Server: Received from Client {ip}:{port}: {arg1.data}");

        foreach (var input in FindObjectsOfType<PlayerInput>())
            input.Deserialize(arg1.data);
    }

    private void OnClose(Object arg0, Socket arg1)
    {
        var ip = ((IPEndPoint) arg1?.RemoteEndPoint)?.Address;
        var port = ((IPEndPoint) arg1.RemoteEndPoint)?.Port ?? -1;
        var clientInfo = ip != null ? $" {ip}:{port}" : "";
        Debug.Log($"Server: Client{clientInfo} disconnected!");
    }
}