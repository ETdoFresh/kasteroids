using UnityEngine;

[RequireComponent(typeof(Transform), typeof(Rigidbody2D))]
public class Bullet : MonoBehaviour
{
    public new Rigidbody2D rigidbody;
    public float maxVelocity = 5;
    public float destroyTime = 1;

    private void OnValidate()
    {
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void OnEnable()
    {
        rigidbody.velocity = transform.up * maxVelocity;
        Destroy(gameObject, destroyTime);
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.bullets.Add(this);
    }

    private void OnDisable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            worldState.bullets.Remove(this);
    }
}