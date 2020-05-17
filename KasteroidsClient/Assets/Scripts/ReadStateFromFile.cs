using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

[RequireComponent(typeof(WorldState))]
public class ReadStateFromFile : MonoBehaviour
{
    public WorldState worldState;
    public string filename = "state.bin";
    public FileStream fileStream;

    private void OnValidate()
    {
        if (!worldState) worldState = GetComponent<WorldState>();
    }

    private void OnEnable()
    {
        fileStream = File.Open(filename, FileMode.OpenOrCreate, FileAccess.Read, FileShare.ReadWrite);
    }

    private void OnDisable()
    {
        fileStream.Close();
    }

    private void FixedUpdate()
    {
        var length = fileStream.Length;
        var bytes = new byte[length];
        fileStream.Position = 0;
        fileStream.Read(bytes, 0, (int)length);
        worldState.Deserialize(Encoding.UTF8.GetString(bytes));
    }
}