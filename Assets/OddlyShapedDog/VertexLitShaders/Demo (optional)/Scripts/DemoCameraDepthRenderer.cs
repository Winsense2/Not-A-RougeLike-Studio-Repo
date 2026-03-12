using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OddlyShapedDogDemo
{
    public class DemoCameraDepthRenderer : MonoBehaviour
    {
        public DepthTextureMode depthTextureMode = DepthTextureMode.None;

        void Start()
        {
            GetComponent<Camera>().depthTextureMode = depthTextureMode;
        }
    }
}
