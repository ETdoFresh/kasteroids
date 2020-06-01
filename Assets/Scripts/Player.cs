using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.UIElements;

public class Player : MonoBehaviour
{
    public Nickname nickname;
    public Id id;
    public Ship ship;
    public Socket socket;
    public PlayerInput input;
}