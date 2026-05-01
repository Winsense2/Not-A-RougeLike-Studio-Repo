using TMPro;
using UnityEngine;

public class HandlePopUp : MonoBehaviour
{
    [SerializeField] TextMeshPro text;

    bool active;

    void Start()
    {
        active = false;
        gameObject.GetComponent<SpriteRenderer>().enabled = active;
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

            gameObject.GetComponent<SpriteRenderer>().enabled = active;
        }

        if (Input.GetKeyDown(KeyCode.H))
        {
            text.text = "<b><color=purple>Enchanted</color></b> Forest";
        }
    }
}
