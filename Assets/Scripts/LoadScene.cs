using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadScene : MonoBehaviour
{
    public void Load(int sceneBuildIndex) => SceneManager.LoadScene(sceneBuildIndex);
    public void Load(string sceneName) => SceneManager.LoadScene(sceneName);
}