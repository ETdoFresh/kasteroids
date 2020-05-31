using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class FindObjectsOfTypeExtension
{
    public static IEnumerable<T> FindObjectsOfTypeInScene<T>(this Component _component) where T : Component
        => FindObjectsOfTypeInScene<T>(_component.gameObject.scene);

    public static IEnumerable<T> FindObjectsOfTypeInScene<T>(this GameObject gameObject) where T : Component
        => FindObjectsOfTypeInScene<T>(gameObject.scene);

    public static IEnumerable<T> FindObjectsOfTypeInScene<T>(this Scene scene) where T : Component
        => Object.FindObjectsOfType<T>().Where(obj => obj.gameObject.scene == scene);

    public static T FindObjectOfTypeInScene<T>(this Component _component) where T : Component
        => FindObjectOfTypeInScene<T>(_component.gameObject.scene);

    public static T FindObjectOfTypeInScene<T>(this GameObject gameObject) where T : Component
        => FindObjectOfTypeInScene<T>(gameObject.scene);

    public static T FindObjectOfTypeInScene<T>(this Scene scene) where T : Component
        => FindObjectsOfTypeInScene<T>(scene).FirstOrDefault();
}