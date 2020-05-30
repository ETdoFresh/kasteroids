using System.Net.Sockets;
using CSharpNetworking;
using UnityEngine;
using UnityNetworking;

public class Server : MonoBehaviour
{
    public TCPServerUnity server;
    public PlayerInput input;

    private void OnValidate()
    {
        if (!server) server = GetComponent<TCPServerUnity>();
        if (!input) input = GetComponent<PlayerInput>();
    }

    private void OnEnable()
    {
#if UNITY_EDITOR
        UnityEditor.Events.UnityEventTools.AddPersistentListener(server.OnMessage, OnMessage);
#else
        server.OnMessage.AddListener(OnMessage);
#endif
    }

    private void OnMessage(Object tcpServer, Message<Socket> message)
    {
        Debug.Log(message.data);
        input.Deserialize(message.data);
    }
}