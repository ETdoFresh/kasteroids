using System.Security.Cryptography;
using UnityEngine;

[RequireComponent(typeof(Transform), typeof(Rigidbody2D))]
public class Asteroid : MonoBehaviour
{
    public new Rigidbody2D rigidbody;
    public float minSize = 0.5f;
    public float maxSize = 1.75f;
    public float maxVelocity = 5;
    public float maxAngularVelocity = 180;

    private void OnValidate()
    {
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void OnEnable()
    {
        transform.eulerAngles = new Vector3(0, 0, Random.Range(0, 360));
        transform.localScale = Vector3.one * Random.Range(minSize, maxSize);
        rigidbody.velocity = Random.insideUnitCircle * maxVelocity;
        rigidbody.angularVelocity = Random.value * maxAngularVelocity;
        
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.asteroids.Add(this);
    }

    private void OnDisable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.asteroids.Remove(this);
    }
}