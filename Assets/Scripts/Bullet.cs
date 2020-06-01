using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public new Rigidbody2D rigidbody;
    public float velocity = 3f;
    public float destroyAfter = 1f;

    private void OnValidate()
    {
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void OnEnable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            if (gameObject.scene == worldState.gameObject.scene)
                worldState.bullets.Add(this);

        rigidbody.velocity += (Vector2) transform.up * velocity;
        Destroy(gameObject, destroyAfter);
    }

    private void OnDisable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            if (gameObject.scene == worldState.gameObject.scene)
                worldState.bullets.Remove(this);
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        Destroy(gameObject);
    }
}