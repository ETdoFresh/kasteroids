using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

[RequireComponent(typeof(WorldState))]
public class WriteStateToFile : MonoBehaviour
{
    public string filename = "state.bin";
    public FileStream fileStream;
    public WorldState worldState;
    public long timesWritten;
    public int debugRate = 3;
    public int lastWritten = 0;

    private void OnValidate()
    {
        if (!worldState) worldState = GetComponent<WorldState>();
    }

    private void OnEnable()
    {
        fileStream = File.Open(filename, FileMode.OpenOrCreate, FileAccess.Write, FileShare.Read);
    }

    private void OnDisable()
    {
        fileStream.Close();
    }

    private void FixedUpdate()
    {
        var serialized = worldState.Serialize();
        var bytes = Encoding.UTF8.GetBytes(serialized);
        fileStream.Position = 0;
        fileStream.Write(bytes, 0, bytes.Length);
        timesWritten++;
        
        if (Time.time >= lastWritten)
        {
            lastWritten += debugRate;
            Debug.Log($"t: {Time.time} c: {timesWritten} d: {serialized}");
        }
    }
}
