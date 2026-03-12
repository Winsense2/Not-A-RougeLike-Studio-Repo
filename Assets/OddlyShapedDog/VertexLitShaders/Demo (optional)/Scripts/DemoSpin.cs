using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OddlyShapedDogDemo
{
  public class DemoSpin : MonoBehaviour
  {
    public Vector3 speed = new Vector3(0f, -10.0f, 0f);

    void Update()
    {
      transform.Rotate(speed * Time.deltaTime);
    }
  }
}