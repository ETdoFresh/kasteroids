using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

[RequireComponent(typeof(Rigidbody2D))]
public class Asteroid : MonoBehaviour
{
    public new Rigidbody2D rigidbody;
    public float minScale = 0.5f;
    public float maxScale = 2f;
    public float minVelocity = 1f;
    public float maxVelocity = 5f;
    public float minAngularVelocity = 1f;
    public float maxAngularVelocity = 5f;

    private void OnValidate()
    {
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void OnEnable()
    {
        RandomizeScale();
        RandomizeRotation();
        RandomizeVelocity();
    }

    private void OnDisable()
    {
        rigidbody.velocity = Vector2.zero;
        rigidbody.angularVelocity = 0;
    }

    private void RandomizeScale()
    {
        var scale = Random.Range(minScale, maxScale);
        transform.localScale = new Vector3(scale, scale, scale);
    }

    private void RandomizeRotation()
    {
        var rotation = Random.Range(0f, 360f);
        var rotationVector = new Vector3(0,0, rotation);
        transform.eulerAngles = rotationVector;
    }

    private void RandomizeVelocity()
    {
        var velocityMagnitude = Random.Range(minVelocity, maxVelocity);
        var velocity = Random.insideUnitCircle;
        velocity *= velocityMagnitude;
        rigidbody.velocity = velocity;

        var angularVelocity = Random.Range(minAngularVelocity, maxAngularVelocity);
        rigidbody.angularVelocity = angularVelocity;
        
        if (rigidbody.velocity.magnitude > maxVelocity)
            rigidbody.velocity = rigidbody.velocity.normalized * maxScale;
    }
}
