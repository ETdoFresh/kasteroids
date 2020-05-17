using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerInput : MonoBehaviour
{
    public int id;

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

    public Text playerTitle;

    private void Update()
    {
        var horizontal = Input.GetAxisRaw("Horizontal");
        var vertical = Input.GetAxisRaw("Vertical");
        up = vertical > 0;
        down = vertical < 0;
        left = horizontal < 0;
        right = horizontal > 0;
        fire = Input.GetButton("Fire1") || Input.GetButton("Jump");
        playerTitle.text = $"Player {id}";

        upImage.color = up ? Color.gray : Color.white;
        downImage.color = down ? Color.gray : Color.white;
        leftImage.color = left ? Color.gray : Color.white;
        rightImage.color = right ? Color.gray : Color.white;
        fireImage.color = fire ? Color.gray : Color.white;
    }

    public string Serialize()
    {
        return $"{id},{up},{down},{left},{right},{fire},";
    }

    public byte[] SerializeBytes()
    {
        return new byte[]
        {
            (byte) (up ? 0 : 1),
            (byte) (down ? 0 : 1),
            (byte) (left ? 0 : 1),
            (byte) (right ? 0 : 1),
            (byte) (fire ? 0 : 1),
        };
    }
}