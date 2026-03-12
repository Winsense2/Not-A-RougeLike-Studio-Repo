using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OddlyShapedDogDemo
{
    public class DemoTextureSwapper : MonoBehaviour
    {
        public Material[] materials;
        public float mixSpeed = 0.5f;
        public AnimationCurve mixValueOverTime = new AnimationCurve();
        private float t = 0.0f;

        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
            t += Time.deltaTime * mixSpeed;
            t = t % 1.0f;
            foreach (Material mat in materials)
            {
                float mixValue = mixValueOverTime.Evaluate(t);
                mat.SetFloat("_MixFactor", mixValue);
            }
        }
    }
}
