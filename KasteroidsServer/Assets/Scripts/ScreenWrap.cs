using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenWrap : MonoBehaviour
{
    public Camera camera;
    public Vector2 screenMax;
    public Vector2 screenMin;
    public Vector2 screenSize;

    private void OnValidate()
    {
        if (!camera) camera = Camera.main;
    }

    private void OnEnable()
    {
        if (!camera) camera = Camera.main;
        screenMin = camera.ViewportToWorldPoint(Vector3.zero);
        screenMax = camera.ViewportToWorldPoint(Vector3.one);
        screenSize = screenMax - screenMin;
    }

    void FixedUpdate()
    {
        var position = transform.position;
        if (position.x < screenMin.x) position.x += screenSize.x;
        if (position.x > screenMax.x) position.x -= screenSize.x;
        if (position.y < screenMin.y) position.y += screenSize.y;
        if (position.y > screenMax.y) position.y -= screenSize.y;
        transform.position = position;
    }
}
