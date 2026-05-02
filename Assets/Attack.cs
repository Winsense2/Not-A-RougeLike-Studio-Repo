using UnityEngine;

public class Attack : MonoBehaviour
{
    [SerializeField] Animator animator;
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            animator.SetTrigger("Attack");
        }
    }
}
