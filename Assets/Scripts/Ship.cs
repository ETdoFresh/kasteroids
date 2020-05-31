using UnityEngine;

public class Ship : CustomMonoBehaviour
{
    public new Transform transform;
    public new Rigidbody2D rigidbody;
    public PlayerInput playerInput;
    public float force = 5f;
    public float maxVelocity = 2f;
    public float rotateSpeed = 360f;

    public GameObject gun;
    public GameObject bulletPrefab;

    private void OnValidate()
    {
        if (!transform) transform = GetComponent<Transform>();
        if (!rigidbody) rigidbody = GetComponent<Rigidbody2D>();
        if (!playerInput) playerInput = FindObjectOfType<PlayerInput>();
    }

    private void OnEnable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            if (gameObject.scene == worldState.gameObject.scene)
                worldState.ships.Add(gameObject);
    }

    private void OnDisable()
    {
        foreach (var worldState in FindObjectsOfType<WorldState>())
            if (gameObject.scene == worldState.gameObject.scene)
                worldState.ships.Remove(gameObject);
    }

    private void FixedUpdate()
    {
        var left = playerInput.left;
        var right = playerInput.right;
        var up = playerInput.up;
        var down = playerInput.down;
        var fire = playerInput.fire;
        var vertical = up ? 1 : down ? -1 : 0;
        var horizontal = left ? -1 : right ? 1 : 0;

        rigidbody.AddForce(transform.up * (vertical * force));

        if (rigidbody.velocity.magnitude > maxVelocity)
            rigidbody.velocity = rigidbody.velocity.normalized * maxVelocity;

        var eulerAngles = transform.eulerAngles;
        eulerAngles.z += horizontal * -rotateSpeed * Time.fixedDeltaTime;
        transform.eulerAngles = eulerAngles;

        if (fire)
        {
            var bullet = Instantiate(bulletPrefab, gun.transform.position, gun.transform.rotation);
            bullet.GetComponent<Rigidbody2D>().velocity += rigidbody.velocity;
        }
    }
}