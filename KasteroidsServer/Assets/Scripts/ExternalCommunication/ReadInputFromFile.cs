using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public class ReadInputFromFile : MonoBehaviour
{
    public PlayerInput input;
    public string filename = "input1.bin";
    public FileStream fileStream;
    
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
        input.Deserialize(Encoding.UTF8.GetString(bytes));
    }
}