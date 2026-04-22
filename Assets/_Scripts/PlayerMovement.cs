using UnityEngine;
using Cinemachine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField] float NormalSpeed = 15f;
    [SerializeField] float SprintSpeed = 30f;

    private float CurrentSpeed;

    [SerializeField] float TurnSpeed = 7f;
    [SerializeField] float CameraTurnAmount = 0.05f;

    [SerializeField] GameObject Camera;
    private ThirdPersonCameraMove thirdPersonCameraMove;

    [SerializeField] private CinemachineVirtualCamera ThirdPersonCamera;
    private Cinemachine3rdPersonFollow followComponent;

    [SerializeField] private Animator animator;

    private void Awake()
    {
        CurrentSpeed = NormalSpeed;
        thirdPersonCameraMove = FindAnyObjectByType<ThirdPersonCameraMove>();

        if (ThirdPersonCamera != null)
        {
            followComponent = ThirdPersonCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>();
        }
    }

    private void FaceWhereAiming()
    {
        Vector3 cameraForward = Camera.transform.forward;

        cameraForward.y = 0f; // Ignore vertical component

        if (cameraForward != Vector3.zero)
        {
            Quaternion targetRotation = Quaternion.LookRotation(cameraForward);
            transform.rotation = targetRotation;
        }
    }

    void Update()
    {
        Vector3 playerPos = transform.position;
        float verticalInput = Input.GetAxis("Vertical");
        float horizontalInput = Input.GetAxis("Horizontal");

        float moveAmountVertical = verticalInput * CurrentSpeed * Time.deltaTime;
        float moveAmountHorizontal = horizontalInput * CurrentSpeed * Time.deltaTime;

        animator.SetFloat("Walking", verticalInput);

        if (Input.GetKey(KeyCode.LeftShift))
        {
            CurrentSpeed = SprintSpeed;
        }
        else if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            CurrentSpeed = NormalSpeed;
        }

        // Detect the moment forward input starts
        if (verticalInput > 0)
        {
            // Get the direction the camera is facing
            Vector3 cameraForward = Camera.transform.forward;

            cameraForward.y = 0f; // Ignore vertical component
            cameraForward.Normalize();

            if (cameraForward != Vector3.zero)
            {
                Quaternion targetRotation = Quaternion.LookRotation(cameraForward);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * TurnSpeed);

                //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(0, 1, 3), 2f);
            }

            playerPos += transform.forward.normalized * moveAmountVertical;
        }

        // Detect the moment backwards input starts
        if (verticalInput < 0)
        {
            Vector3 cameraForward = Camera.transform.forward;
            
            cameraForward.y = 0f; // Ignore vertical component
            cameraForward.Normalize();

            if (cameraForward != Vector3.zero)
            {
                Quaternion targetRotation = Quaternion.LookRotation(-cameraForward);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * TurnSpeed);

                //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(0, 1, -3), 2f);
            }

            playerPos -= transform.forward.normalized * moveAmountVertical;
        }

        if (verticalInput < 1)
        {
            //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(0, 1, 0), 0.5f);
        }

        if (horizontalInput > 0)
        {
            Vector3 cameraRight = Camera.transform.right;
            
            cameraRight.y = 0f;
            cameraRight.Normalize();

            if (cameraRight != Vector3.zero)
            {
                Quaternion targetRotation = Quaternion.LookRotation(cameraRight);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * TurnSpeed);

                //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(3, 1, 0), 2f);
            }

            thirdPersonCameraMove.rotation.x += CameraTurnAmount;
            playerPos += transform.forward.normalized * moveAmountHorizontal;
        }

        if (horizontalInput < 0)
        {
            Vector3 cameraRight = Camera.transform.right;
            
            cameraRight.y = 0f;
            cameraRight.Normalize();

            if (cameraRight != Vector3.zero)
            {
                Quaternion targetRotation = Quaternion.LookRotation(-cameraRight);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * TurnSpeed);

                //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(-3, 1, 0), 2f);
            }

            thirdPersonCameraMove.rotation.x -= CameraTurnAmount;
            playerPos -= transform.forward.normalized * moveAmountHorizontal;
        }

        if (Input.GetKeyUp(KeyCode.D) || Input.GetKeyUp(KeyCode.A))
        {
            //DOTween.To(() => followComponent.ShoulderOffset, x => followComponent.ShoulderOffset = x, new Vector3(0, 1, 0), 0.5f);
            thirdPersonCameraMove.rotation.x -= 0f;
        }

        transform.position = playerPos;
    }
}