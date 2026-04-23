using UnityEngine;

public class CameraMove : MonoBehaviour
{
    [Range(0f, 100f)][SerializeField] private float sensitivity;
    [SerializeField] private float clamp = 6f;
    
    private float _xRotate;
    private float _yRotate;

    private void Update()
    {
        var mousePosX = Input.GetAxis("Mouse X") * sensitivity * Time.deltaTime;
        var mousePosY = Input.GetAxis("Mouse Y") * sensitivity * Time.deltaTime;
        
        _xRotate -= mousePosY;
        _yRotate += mousePosX;
        
        _xRotate = Mathf.Clamp(_xRotate, -clamp, clamp);
        _yRotate = Mathf.Clamp(_yRotate, -clamp, clamp);
        
        transform.rotation = Quaternion.Euler(_xRotate, _yRotate, 0f);
    }
}
