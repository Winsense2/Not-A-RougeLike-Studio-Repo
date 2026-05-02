using System.Collections.Generic;
using UnityEngine;

public class ShowPlayers : MonoBehaviour
{
    [SerializeField] List<SkinnedMeshRenderer> playerSkin = new List<SkinnedMeshRenderer>();
    [SerializeField] List<GameObject> nametag = new List<GameObject>();

    void Start()
    {
        foreach (SkinnedMeshRenderer skin in playerSkin)
        {
            skin.enabled = false;
        }

        foreach (GameObject name in nametag)
        {
           name.SetActive(false);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.G))
        {
            foreach (SkinnedMeshRenderer skin in playerSkin)
            {
                skin.enabled = true;
            }

            foreach (GameObject name in nametag)
            {
                name.SetActive(true);
            }
        }
    }
}
