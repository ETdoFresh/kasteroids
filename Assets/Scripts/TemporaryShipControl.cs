using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditorInternal;
using UnityEngine;

public class TemporaryShipControl : MonoBehaviour
{
    public new Transform transform;
    public new Rigidbody2D rigidbody;
    public float force = 5f;
    public float maxVelocity = 2f;
    public float rotateSpeed = 360f;

    public bool fire1Down;

    public GameObject gun;
    public GameObject bulletPrefab;
    
    private void OnValidate()
    {
        if (!transform) transform = GetComponent<Transform>();
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
    }

    private void Update()
    {
        if (Input.GetButton("Fire1") || Input.GetButton("Jump"))
            fire1Down = true;
    }

    private void FixedUpdate()
    {
        var horizontal = Input.GetAxisRaw("Horizontal");
        var vertical = Input.GetAxisRaw("Vertical");
        
        rigidbody.AddForce(transform.up * (vertical * force));

        if (rigidbody.velocity.magnitude > maxVelocity)
            rigidbody.velocity = rigidbody.velocity.normalized * maxVelocity;
        
        var eulerAngles = transform.eulerAngles;
        eulerAngles.z += horizontal * -rotateSpeed * Time.fixedDeltaTime;
        transform.eulerAngles = eulerAngles;

        if (fire1Down)
        {
            var bullet = Instantiate(bulletPrefab, gun.transform.position, gun.transform.rotation);
            bullet.GetComponent<Rigidbody2D>().velocity += rigidbody.velocity;
            fire1Down = false;
        }
    }
}
