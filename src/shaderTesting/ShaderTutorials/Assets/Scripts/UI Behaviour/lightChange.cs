using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lightChange : MonoBehaviour
{
    public Light mainLight;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("d"))
        {
            mainLight.type = LightType.Directional;
        }
        else if (Input.GetKeyDown("p"))
        {
            mainLight.type = LightType.Point;
        }
        else if (Input.GetKeyDown("s"))
        {
            mainLight.type = LightType.Spot;
        }

        if (Input.GetKeyDown("left"))
        {
            mainLight.transform.Translate(-0.1f,0f,0f);
        }

        if (Input.GetKeyDown("right"))
        {
            mainLight.transform.Translate(0.1f, 0f, 0f);
        }

        if (Input.GetKeyDown("up"))
        {
            mainLight.transform.Translate(0f, 0.1f, 0f);
        }

        if (Input.GetKeyDown("down"))
        {
            mainLight.transform.Translate(0f, -0.1f, 0f);
        }

        if (Input.GetKeyDown("="))
        {
            if (mainLight.intensity < 1)
            {
                mainLight.intensity = mainLight.intensity + 0.1f;
            }
        }

        if (Input.GetKeyDown("-"))
        {
            if (mainLight.intensity > 0)
            {
                mainLight.intensity = mainLight.intensity - 0.1f;
            }
        }

    }
}
