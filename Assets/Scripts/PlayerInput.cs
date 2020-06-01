using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public class PlayerInput : MonoBehaviour
{
    public Player player;

    public bool controlLocally;

    public bool up;
    public bool down;
    public bool left;
    public bool right;
    public bool fire;

    public Image upImage;
    public Image downImage;
    public Image leftImage;
    public Image rightImage;
    public Image fireImage;
    public Text playerText;

    private void FixedUpdate()
    {
        if (controlLocally)
        {
            var horizontal = Input.GetAxisRaw("Horizontal");
            var vertical = Input.GetAxisRaw("Vertical");
            up = vertical > 0;
            down = vertical < 0;
            left = horizontal < 0;
            right = horizontal > 0;
            fire = Input.GetButton("Fire1") || Input.GetButton("Jump");
        }

        if (upImage)
        {
            upImage.color = up ? Color.gray : Color.white;
            downImage.color = down ? Color.gray : Color.white;
            leftImage.color = left ? Color.gray : Color.white;
            rightImage.color = right ? Color.gray : Color.white;
            fireImage.color = fire ? Color.gray : Color.white;
        }

        if (playerText)
            if (player)
                playerText.text = $"Player {player.id}: {player.nickname}";
            else
                playerText.text = $"<Unassigned>";
    }

    public string Serialize()
    {
        return $"{player.id},{up},{down},{left},{right},{fire},";
    }

    public void Deserialize(string serialized)
    {
        if (!player) return;

        var args = serialized.Split(',');
        if (player.id.value != Convert.ToInt32(args[0])) return;
        up = Convert.ToBoolean(args[1]);
        down = Convert.ToBoolean(args[2]);
        left = Convert.ToBoolean(args[3]);
        right = Convert.ToBoolean(args[4]);
        fire = Convert.ToBoolean(args[5]);
    }
}