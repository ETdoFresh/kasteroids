using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class ShipControls : MonoBehaviour
{
    public int playerId;
    public PlayerInput playerInput;
    public new Rigidbody2D rigidbody;
    public float force = 2.5f;
    public float turnSpeed = 270;
    public float maxSpeed = 2.5f;
    public GameObject bulletPrefab;
    public Transform gun;

    private void OnValidate()
    {
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void OnEnable()
    {
        playerInput = FindObjectsOfType<PlayerInput>().FirstOrDefault(p => p.id == playerId);
    }

    public void SetId(int id)
    {
        playerId = id;
        playerInput = FindObjectsOfType<PlayerInput>().FirstOrDefault(p => p.id == playerId);
        if (!playerInput) playerInput = gameObject.AddComponent<PlayerInput>();
        playerInput.id = id;
    }

    private void FixedUpdate()
    {
        if (playerInput)
        {
            if (playerInput.up)
                rigidbody.AddForce(transform.up * force);
            if (playerInput.down)
                rigidbody.AddForce(transform.up * -force);
            if (playerInput.left)
                transform.eulerAngles += new Vector3(0, 0, turnSpeed * Time.deltaTime);
            if (playerInput.right)
                transform.eulerAngles -= new Vector3(0, 0, turnSpeed * Time.deltaTime);

            if (playerInput.fire)
                Instantiate(bulletPrefab, gun.position, gun.rotation);
            
            if (rigidbody.velocity.magnitude > maxSpeed)
                rigidbody.velocity = rigidbody.velocity.normalized * maxSpeed;
        }
    }
}