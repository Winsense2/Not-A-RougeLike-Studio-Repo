using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class HandlePopUp : MonoBehaviour
{
    [SerializeField] TextMeshPro text;
    [SerializeField] List<SpriteRenderer> sprites = new List<SpriteRenderer>();
    [SerializeField] SpriteRenderer icon;

    bool active;

    void Start()
    {
        active = false;
        foreach(SpriteRenderer sprite in sprites)
        {
            sprite.enabled = active;
        }
    }

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.G))
        {
            if (!active)
            {
                active = true;
            }
            else
            {
                active = false;
            }

            foreach(SpriteRenderer sprite in sprites)
            {
                sprite.enabled = active;
            }
        }

        if (Input.GetKeyDown(KeyCode.H))
        {
            text.text = "<b><color=purple>Enchanted</color></b> Forest";
            icon.enabled = true;
        }
    }
}
