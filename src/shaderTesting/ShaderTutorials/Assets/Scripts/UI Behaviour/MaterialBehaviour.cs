using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;


/* Module Name: Material Behaviour
 */
public class MaterialBehaviour : MonoBehaviour
{
    Renderer obj_rend;
    Material obj_material;
    private float colourR, colourG, colourB;
    private float shine, diff, spec;
    public Slider colourRed, colourGreen, colourBlue;
    public Slider alpha;
    public Slider diffCoeff;
    public Slider specCoeff;

     private void Start()
    {
        obj_rend = GetComponent<Renderer>();   //Get material of object.    
        obj_material = obj_rend.material;
        colourR = obj_material.color.r;
        colourG = obj_material.color.g;
        colourB = obj_material.color.b;
        shine = obj_material.GetFloat("_Shininess");
        spec = obj_material.GetFloat("_SpecularCoefficient");
        diff = obj_material.GetFloat("_DiffuseCoefficient");
        //Set Slider values initially
        colourRed.value = colourR;
        colourGreen.value = colourG;
        colourBlue.value = colourB;
        alpha.value = shine;
        diffCoeff.value = diff;
        specCoeff.value = spec;
    }

    void Update()
    {
        obj_material.SetColor("_Color", new Color (colourR, colourG, colourB, 1.0f));
    }

    //Have Slider set the ks
    public void SetSpecCoefficient(float ks)
    {
        obj_material.SetFloat("_SpecularCoefficient", ks);
    }

    public void SetDiffCoefficient(float kd)
    {
        obj_material.SetFloat("_DiffuseCoefficient", kd);
    }

    public void SetShininess(float alpha)
    {
        obj_material.SetFloat("_Shininess", alpha);
    }

    public void SetShaderModel(int index)
    {
        Shader temp;

        switch (index)
        {
            case 0:
                temp = Shader.Find("Custom/Sasha-Lambert");
                Debug.Log("temp is set to Lambert");
                break;
            case 1:
                temp = Shader.Find("Unlit/Sasha-ModLambert");
                Debug.Log("temp is set to Mod-Lambert");
                break;
            case 2:
                temp = Shader.Find("Custom/Sasha-Phong");
                Debug.Log("temp is set to Phong");
                break;
            case 3:
                temp = Shader.Find("Custom/Sasha-BlinnPhong");
                Debug.Log("temp is set to Blinn-Phong");
                break;
            default:
                temp = Shader.Find("Custom/Sasha-Lambert");
                break;
        }
        obj_material.shader = temp;
    }

    public void SetColourR(float r)
    {
        colourR = r;
    }

    public void SetColourG(float g)
    {
        colourG = g;
    }

    public void SetColourB(float b)
    {
        colourB = b;
    }
}
