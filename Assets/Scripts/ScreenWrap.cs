using UnityEngine;

public class ScreenWrap : MonoBehaviour
{
    public new Camera camera;
    public float left;
    public float right;
    public float top;
    public float bottom;
    public Vector2 size;

    private void OnValidate()
    {
        if (!camera) camera = FindObjectOfType<Camera>();
    }

    private void OnEnable()
    {
        var min = camera.ViewportToWorldPoint(Vector3.zero);
        var max = camera.ViewportToWorldPoint(Vector3.one);
        left = min.x;
        bottom = min.y;
        right = max.x;
        top = max.y;
        size = max - min;
    }

    private void FixedUpdate()
    {
        var position = transform.position;

        if (position.x < left) position.x += size.x;
        if (position.x > right) position.x -= size.x;
        if (position.y < bottom) position.y += size.y;
        if (position.y > top) position.y -= size.y;

        transform.position = position;
    }
}
