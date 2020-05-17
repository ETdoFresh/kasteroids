using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using CSharpNetworking;
using UnityEngine;
using UnityNetworking;
using Object = UnityEngine.Object;

public class TCPClient : MonoBehaviour
{
    public WorldState worldState;
    public PlayerInput input;
    public TCPClientUnity client;

    private void OnEnable()
    {
        client.OnOpen.AddListener(OnOpen);
        client.OnMessage.AddListener(OnMessage);
        client.OnClose.AddListener(OnClose);
    }

    private void OnDisable()
    {
        client.OnOpen.RemoveListener(OnOpen);
        client.OnMessage.RemoveListener(OnMessage);
        client.OnClose.RemoveListener(OnClose);
    }

    private void OnOpen(Object arg0)
    {
        Debug.Log($"Client connected!");
    }

    private void OnMessage(Object arg0, Message arg1)
    {
        Debug.Log($"Received from Server: {arg1.data}");
        
        worldState.Deserialize(arg1.data);
    }

    private void OnClose(Object arg0)
    {
        Debug.Log($"Client disconnected!");
    }

    private void FixedUpdate()
    {
        if (input && client)
            client.Send(input.Serialize());
    }
}
