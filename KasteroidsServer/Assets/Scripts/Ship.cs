using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Ship : MonoBehaviour
{
    private void OnEnable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.ships.Add(this);
    }

    private void OnDisable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.ships.Remove(this);
    }
}