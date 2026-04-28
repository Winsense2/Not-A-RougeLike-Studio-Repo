using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    [SerializeField] bool rotate;
    [SerializeField] float zOffest = -0.5f;

    Transform ikTarget;

    void Awake()
    {
        ikTarget = transform;
    }

    void LateUpdate()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            ikTarget.position = hit.point + new Vector3 (0f, 0f, zOffest);

            if (rotate)
            {
                Quaternion targetRotation = Quaternion.FromToRotation(-Vector3.right, hit.normal);
                ikTarget.rotation = Quaternion.Slerp(ikTarget.rotation, targetRotation, Time.deltaTime * 10f);
            }     
        }
    }
}
