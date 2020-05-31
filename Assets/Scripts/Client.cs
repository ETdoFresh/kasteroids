using System.Linq;
using Commands;
using CSharpNetworking;
using UnityEngine;
using UnityNetworking;
using Object = UnityEngine.Object;

public class Client : MonoBehaviour
{
    public TCPClientUnity client;
    public PlayerInput input;
    public WorldState worldState;

    private void OnValidate()
    {
        if (!client) client = GetComponent<TCPClientUnity>();
        if (!input) input = FindObjectOfType<PlayerInput>();
        if (!worldState) worldState = FindObjectOfType<WorldState>();
    }

    private void OnEnable()
    {
#if UNITY_EDITOR
        UnityEditor.Events.UnityEventTools.AddPersistentListener(client.OnMessage, OnMessage);
#else
        client.OnMessage.AddListener(OnMessage);
#endif
    }

    private void OnMessage(Object tcpClient, Message message)
    {
        //Debug.Log(message.data);
        if (message.data.StartsWith("GetName"))
            new GetName().Receive(client, message.data.Split(',').Skip(1).ToArray());
        else
            worldState.Deserialize(message.data);
    }

    private void FixedUpdate()
    {
        client.Send(input.Serialize());
    }
}