using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadScene : MonoBehaviour
{
    public void Load(int sceneBuildIndex) => SceneManager.LoadScene(sceneBuildIndex);
    public void Load(string sceneName) => SceneManager.LoadScene(sceneName);

    public void Load12()
    {
        SceneManager.LoadScene(1);
        SceneManager.LoadScene(2, LoadSceneMode.Additive);
    }
}