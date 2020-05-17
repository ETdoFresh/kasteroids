using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public class WriteInputToFile : MonoBehaviour
{
    public PlayerInput input;
    public string filename = "input1.bin";
    public FileStream fileStream;
    public long timesWritten;
    public int debugRate = 3;
    public int lastWritten = 0;
    
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
        var serialized = input.Serialize();
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
