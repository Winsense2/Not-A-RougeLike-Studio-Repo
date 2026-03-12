using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace OddlyShapedDogDemo
{
  public class DemoCyclePositionOnInput : MonoBehaviour
  {
    const float SNAP_DISTANCE = 0.1f;

    public Vector3[] positions;
    public float interval = 0.25f;
    public AnimationCurve easing;

    private bool isAnimating = false;
    private int currentPositionIdx;
    private int targetPositionIdx;
    private float t = 0f;

    void Start()
    {
      currentPositionIdx = 0;
      targetPositionIdx = 0;
      SnapToCurrentPosition();
    }

    void SnapToCurrentPosition()
    {
      transform.localPosition = positions[currentPositionIdx];
    }

    void Update()
    {
      if (Input.GetKeyUp("right"))
      {
        currentPositionIdx = targetPositionIdx;
        SnapToCurrentPosition();
        targetPositionIdx = (targetPositionIdx + 1) % positions.Length;
        t = interval;
        isAnimating = true;
      }
      else if (Input.GetKeyUp("left"))
      {
        currentPositionIdx = targetPositionIdx;
        SnapToCurrentPosition();
        targetPositionIdx = (positions.Length + targetPositionIdx - 1) % positions.Length;
        t = interval;
        isAnimating = true;
      }
      
      if (isAnimating)
      {
        t -= Time.deltaTime;

        float animT = 1f - Mathf.Clamp01(t / interval);
        animT = easing.Evaluate(animT);
        Vector3 from = positions[currentPositionIdx];
        Vector3 to = positions[targetPositionIdx];
        Vector3 desiredPosition = Vector3.Lerp(from, to, animT);
        transform.localPosition = desiredPosition;
      }
    }
  }
}