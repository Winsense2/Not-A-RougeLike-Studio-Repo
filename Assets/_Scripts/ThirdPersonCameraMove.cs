using System;
using UnityEngine;

public class ThirdPersonCameraMove : MonoBehaviour
{
    [Range(0f ,300f)][SerializeField] float sensitivity;

    [SerializeField] float yClamp = 88f;

    [HideInInspector]public Vector2 rotation = Vector2.zero;
    void LateUpdate()
    {
        rotation.x += Input.GetAxis("Mouse X") * sensitivity * Time.deltaTime;
        rotation.y += Input.GetAxis("Mouse Y") * sensitivity * Time.deltaTime;

        rotation.y = Mathf.Clamp(rotation.y, -yClamp, yClamp);

        var xQat = Quaternion.AngleAxis(rotation.x, Vector3.up);
        var yQat = Quaternion.AngleAxis(rotation.y, Vector3.left);

        transform.rotation = xQat * yQat;
    }
}