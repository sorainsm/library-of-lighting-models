using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum LightTypes
{
    DirectionalLight = 0,
    SpotLight = 1,
    PointLight = 2
}

/* Module Name: LightBehaviour
 * Author: Sasha Soraine
 * MonoBehaviour describes how the light source reacts to input from the user, and then renders the scene.
 * Functionality for this is out-sourced to the LightFunctions module for the sake of easier unit testing.
 */
public class LightBehaviour : MonoBehaviour
{
    public LightFunctions l;
    public Light mainLight;
    public float MAX_INTENSITY, MIN_INTENSITY;
    public GameObject floor, wall_Left, wall_Right, wall_Back, wall_Front, ceiling;
    public IUnityService UnityService;

    // Start is called before the first frame update
    void Start()
    {
        l = new LightFunctions();
        l.floorBound = floor.transform.position.y;
        l.ceilingBound = ceiling.transform.position.y;
        l.leftBound = wall_Left.transform.position.x;
        l.rightBound = wall_Right.transform.position.x;
        l.backBound = wall_Back.transform.position.z;
        l.frontBound = wall_Front.transform.position.z;
        l.mainLight = mainLight;
        l.MAX_INTENSITY = MAX_INTENSITY;
        l.MIN_INTENSITY = MIN_INTENSITY;
        l.lightInitPosition = l.mainLight.transform.position;
        l.lightInitType = l.mainLight.type;
        if (UnityService == null)
        {
            UnityService = new UnityService();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (UnityService.isKeyDown("d"))
        {
            l.ChangeLightType(LightTypes.DirectionalLight);
        }
        else if (UnityService.isKeyDown("p"))
        {
            l.ChangeLightType(LightTypes.PointLight);
        }
        else if (UnityService.isKeyDown("s"))
        {
            l.ChangeLightType(LightTypes.SpotLight);
        }

        if (UnityService.isKeyDown("r"))
        {
            l.DefaultLights();
        }

        if (UnityService.isKeyDown("left"))
        {
            l.MoveLightLeft();
        }

        if (UnityService.isKeyDown("right"))
        {
            l.MoveLightRight();
        }

        if (UnityService.isKeyDown("up"))
        {
            l.MoveLightUp();
        }

        if (UnityService.isKeyDown("down"))
        {
            l.MoveLightDown();
        }

        if (UnityService.isKeyDown("="))
        {
            l.RaiseIntensity();
        }

        if (UnityService.isKeyDown("-"))
        {
            l.LowerIntensity();
        }
    }
}

/* Module Name: LightFunctions
 * Author: Sasha Soraine
 * Computes the changes to the light source based for different scenarios.
 * Works in conjunction with LightBehaviour to connect user input to changes in the object.
 */
public class LightFunctions
{
    public Light mainLight;
    public float MAX_INTENSITY, MIN_INTENSITY;
    public Vector3 lightInitPosition;
    private float INTENSITY_MODIFIER = 0.1f;
    public LightType lightInitType;
    public float floorBound, leftBound, rightBound, backBound, frontBound, ceilingBound;

    public void RaiseIntensity()
    {
        if (mainLight.intensity < MAX_INTENSITY)
        {
            mainLight.intensity = mainLight.intensity + INTENSITY_MODIFIER;
        }
        else
        {
            //do nothing
            Debug.Log("Trying to raise intensity above MAX_INTENSITY");
        }
    }

    public void LowerIntensity()
    {
        if (mainLight.intensity > MIN_INTENSITY)
        {
            mainLight.intensity = mainLight.intensity - INTENSITY_MODIFIER;
        }
        else
        {
            //do nothing
            Debug.Log("Trying to lower the intensity below MIN_INTENSITY");
        }
    }

    public void ChangeLightType(LightTypes e)
    {
        switch (e)
        {
            case LightTypes.DirectionalLight:
                mainLight.type = LightType.Directional;
                Debug.Log("LightType changed to Directional");
                break;
            case LightTypes.SpotLight:
                mainLight.type = LightType.Spot;
                Debug.Log("LightType changed to Spotlight");
                break;
            case LightTypes.PointLight:
                mainLight.type = LightType.Point;
                Debug.Log("LightType changed to Point light");
                break;
        }
    }

    public void MoveLightLeft()
    {
        if (mainLight.transform.position.x > leftBound)
        {
            mainLight.transform.Translate(-0.1f, 0f, 0f);
        }
        else
        {
            //do nothing
            Debug.Log("Light cannot move out of scene bounds - Left");
        }

    }

    public void MoveLightRight()
    {
        if (mainLight.transform.position.x < rightBound)
        {
            mainLight.transform.Translate(0.1f, 0f, 0f);
        }
        else
        {
            //do nothing
            Debug.Log("Light cannot move out of scene bounds - Right");
        }

    }

    public void MoveLightDown()
    {
        if (mainLight.transform.position.y > floorBound)
        {
            mainLight.transform.Translate(0f, -0.1f, 0f);
        }
        else
        {
            Debug.Log("Light cannot move out of scene bounds - Down");
            //do nothing
        }

    }

    public void MoveLightUp()
    {
        if (mainLight.transform.position.y < ceilingBound)
        {
            mainLight.transform.Translate(0f, 0.1f, 0f);
        }
        else
        {
            //do nothing
            Debug.Log("Light cannot move out of scene bounds - Up");
        }
    }

    public void DefaultLights()
    {
        MIN_INTENSITY = 1.0f;
        MAX_INTENSITY = 2.0f;
        mainLight.transform.position = lightInitPosition;
        mainLight.type = lightInitType;
        mainLight.intensity = MIN_INTENSITY;
        Debug.Log("Returned light to default parameters");
    }
}