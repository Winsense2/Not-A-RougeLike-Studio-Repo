using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace OddlyShapedDogDemo
{
    public class DemoTextureSwitcher : MonoBehaviour
    {
        public Texture2D[] textures;
        public string[] textureDescriptions;
        public Material targetMaterial;
        public Text text;

        const float TEXTURE_INTERVAL = 3.66f;

        private float t = 0.3f;
        private int textureIndex = 0;

        // Start is called before the first frame update
        void Start()
        {
            ApplyCurrentTexture();
        }

        // Update is called once per frame
        void Update()
        {
            t += Time.deltaTime;

            while (t >= TEXTURE_INTERVAL)
            {
                t -= TEXTURE_INTERVAL;
                AdvanceToNextTexture();
            }

            if (Input.GetKeyUp(KeyCode.Space) || Input.GetMouseButtonUp(0))
            {
                AdvanceToNextTexture();
            }
        }

        void AdvanceToNextTexture()
        {
            textureIndex = (textureIndex + 1) % textures.Length;
            ApplyCurrentTexture();
        }

        void ApplyCurrentTexture()
        {
            targetMaterial.SetTexture("_MainTex", textures[textureIndex]);
            text.text = textureDescriptions[textureIndex];
        }
    }
}
