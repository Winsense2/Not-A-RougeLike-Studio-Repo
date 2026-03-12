using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OddlyShapedDogDemo
{
    public class DemoVisibilityToggler : MonoBehaviour
    {
        public KeyCode ToggleKey = KeyCode.F;

        private CanvasGroup _canvasGroup;
        private bool _isToggled = false;

        void Awake()
        {
            _canvasGroup = GetComponent<CanvasGroup>();
        }

        void Start()
        {
            _isToggled = _canvasGroup.alpha > 0.5;
            SetToggled(_isToggled);
        }

        void Update()
        {
            if (Input.GetKeyUp(ToggleKey))
            {
                SetToggled(!_isToggled);
            }
        }

        private void SetToggled(bool toggledStatus)
        {
            _isToggled = toggledStatus;
            _canvasGroup.alpha = toggledStatus ? 1.0f : 0.0f;
        }

    }
}
