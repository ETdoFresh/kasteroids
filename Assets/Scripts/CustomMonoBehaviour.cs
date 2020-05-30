using UnityEngine;
using UnityEngine.SceneManagement;

public class CustomMonoBehaviour : MonoBehaviour
{
    public GameObject Instantiate(GameObject prefab)
    {
        var newGameObject = Object.Instantiate(prefab);
        SceneManager.MoveGameObjectToScene(newGameObject, gameObject.scene);
        return newGameObject;
    }
}