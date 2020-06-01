using System.Globalization;
using UnityEngine;

public abstract class MonoBehaviourData : MonoBehaviour { }

public abstract class MonoBehaviourStringData<T> : MonoBehaviourData where T : MonoBehaviourStringData<T> 
{
    public string value;

    protected T Constructor(string value)
    {
        this.value = value;
        return this as T;
    }
    
    public static T AddComponent(GameObject gameObject, string value)
    {
        var t = gameObject.AddComponent<T>();
        t.value = value;
        return t;
    }

    public override string ToString() => value;
}

public abstract class MonoBehaviourIntData<T> : MonoBehaviourData where T : MonoBehaviourIntData<T>
{
    public int value;

    protected T Constructor(int value)
    {
        this.value = value;
        return this as T;
    }

    public static T AddComponent(GameObject gameObject, int value)
    {
        var t = gameObject.AddComponent<T>();
        t.value = value;
        return t;
    }
    
    public override string ToString() => value.ToString();
}

public abstract class MonoBehaviourFloatData<T> : MonoBehaviourData where T : MonoBehaviourFloatData<T>
{
    public float value;

    protected T Constructor(float value)
    {
        this.value = value;
        return this as T;
    }
    
    public static T AddComponent(GameObject gameObject, float value)
    {
        var t = gameObject.AddComponent<T>();
        t.value = value;
        return t;
    }
    
    public override string ToString() => value.ToString(CultureInfo.InvariantCulture);
}

public abstract class MonoBehaviourVector2Data<T> : MonoBehaviourData where T : MonoBehaviourVector2Data<T>
{
    public Vector2 value;

    protected T Constructor(Vector2 value)
    {
        this.value = value;
        return this as T;
    }
    
    public static T AddComponent(GameObject gameObject, Vector2 value)
    {
        var t = gameObject.AddComponent<T>();
        t.value = value;
        return t;
    }
    
    public override string ToString() => value.ToString();
}

public abstract class MonoBehaviourVector3Data<T> : MonoBehaviourData where T : MonoBehaviourVector3Data<T>
{
    public Vector3 value;

    protected T Constructor(Vector3 value)
    {
        this.value = value;
        return this as T;
    }
    
    public static T AddComponent(GameObject gameObject, Vector3 value)
    {
        var t = gameObject.AddComponent<T>();
        t.value = value;
        return t;
    }
    
    public override string ToString() => value.ToString();
}