    using UnityEngine;
    using UnityEngine.SceneManagement;

    public static class MonoBehaviourExtension
    {
        public static GameObject Instantiate(this MonoBehaviour mb, GameObject prefab)
        {
            var gameObject = Object.Instantiate(prefab);
            SceneManager.MoveGameObjectToScene(gameObject, mb.gameObject.scene);
            return gameObject;
        }   
    }