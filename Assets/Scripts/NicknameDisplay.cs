using UnityEngine;
using UnityEngine.UI;

public class NicknameDisplay : MonoBehaviour
{
    public Nickname nickname;
    public Canvas canvas;
    public Text display;

    private void Update()
    {
        if (!canvas.worldCamera)
            canvas.worldCamera = Camera.main;
        
        if (!canvas.worldCamera)
            return;

        if (nickname && display)
        {
            display.text = nickname.value;
            canvas.transform.rotation = Quaternion.identity;
        }
    }
}
