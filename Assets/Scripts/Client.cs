using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityNetworking;

public class Client : MonoBehaviour
{
    public TCPClientUnity client;
    public PlayerInput input;

    private void OnValidate()
    {
        if (!client) client = GetComponent<TCPClientUnity>();
        if (!input) input = FindObjectOfType<PlayerInput>();
    }

    private void FixedUpdate()
    {
        client.Send(input.Serialize());
    }
}
