Shader "Custom/Sasha-Lambert"
{
    /* This script covers the shader and lighting model for a Lambert/Diffuse shader/lighting.
    *  This was constructed using the following tutorials:
    *  1. https://en.wikibooks.org/wiki/Cg_Programming/Unity/Diffuse_Reflection
    *  2. https://tutorialedge.net/gamedev/unity/custom-diffuse-lighting-model-unity-tutorial/
    *  The purpose of constructing the Diffuse model from these tutorials is to understand how to code
    *  lighting models in the CG language (HLSL/GLSL). Other lighting models will be coded from scratch
    *  by me, as per the requirements of the course.
    * 
    *  This shader/lighting model cover Diffuse Reflection for a single directional light, a point light, and a spotlight.
    */

    /*  Diffuse/Lambertian Reflection
    *   Diffuse reflection is the simplest form of reflection, where in objects have no specular highlights - therefore they appear matte and dull.
    *   For all reflection, we take in the incident ray and calculate the output ray; in this case, we specifically focus on the intensity of these.
    *   We calculate the reflected light using the dot product of the incident ray and the normal vector, multiplied by the intensity of the incident ray
    *   and the diffuse coefficient.
    */

    Properties
    {
        _Color("Diffuse Material Color", Color) = (1,1,1,1)    //Base Material Colour
    }

    SubShader
    {
        Pass
        {

            Tags { "LightMode" = "ForwardBase" }  //This makes sure all uniforms are correctly set
            
            CGPROGRAM

            #pragma vertex VertexFunc       //Vertex function for per-vertex shading
            #pragma fragment FragmentFunc   //Fragment function for fragment colour calculation

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;    //Colour of light source
            uniform float4 _Color;          //Colour of material from shader inspector

            struct vertexInput
            {
                float4 vertex : POSITION;   //From mesh; this is the position of the vertex we are currently working with.   
                float3 normal : NORMAL;     //From mesh; this is the normal at the vertex we are currently working with
            };

            struct v2f
            {
                float4 pos : SV_POSITION;   //
                float4 col : COLOR;
            };

            v2f VertexFunc(vertexInput IN)  //This is where the shader actually calculates the vertex colour based on the information from the lighting model.
            {
                v2f OUT;

                float4x4 modelMatrix = unity_ObjectToWorld;
                float4x4 modelMatrixInverse = unity_WorldToObject;
                float3 normalDirection = UnityObjectToWorldNormal(IN.normal);   //Takes the normal at the vertex and converts it from local coordinates to global coordinates
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);    //finds the incident ray between the light position and the vertex when light source is directional
                float attentuation = 1.0;                                             //How the intensity of the light decays with distance                              

                float angleOfReflection = max(0.0, dot(normalDirection, lightDirection)); //Finds the angle of reflection between the incident ray and the normal; I added this by separating out steps from the diffuse equation.

                float3 diffuseReflection = attentuation * _LightColor0.rgb * _Color.rgb * angleOfReflection; //Finds intensity of reflected ray (and therefore the colour of the vertex)

                OUT.col = float4(diffuseReflection, 1.0); //Colours are RGBA values, so diffuseReflection is the RGB and 1 is the alpha for opaque
                OUT.pos = UnityObjectToClipPos(IN.vertex);

                return OUT;
            }

            float4 FragmentFunc(v2f IN) : COLOR //This is where the shader assigns the colour to the fragment.
            {
                return IN.col;
            }

            ENDCG
        }

         Pass
        {
            //Pass for additional light sources
            Tags { "LightMode" = "ForwardAdd" }  //This makes sure all uniforms are correctly set
            Blend One One //Additive Blending

            CGPROGRAM

            #pragma vertex VertexFunc       //Vertex function for per-vertex shading
            #pragma fragment FragmentFunc   //Fragment function for fragment colour calculation

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;    //Colour of light source
            uniform float4 _Color;          //Colour of material from shader inspector

            struct vertexInput
            {
                float4 vertex : POSITION;   //From mesh; this is the position of the vertex we are currently working with.   
                float3 normal : NORMAL;     //From mesh; this is the normal at the vertex we are currently working with
            };

            struct v2f
            {
                float4 pos : SV_POSITION;   //
                float4 col : COLOR;
            };

            v2f VertexFunc(vertexInput IN)  //This is where the shader actually calculates the vertex colour based on the information from the lighting model.
            {
                v2f OUT;

                float4x4 modelMatrix = unity_ObjectToWorld;
                float4x4 modelMatrixInverse = unity_WorldToObject;
                float3 normalDirection = UnityObjectToWorldNormal(IN.normal);   //Takes the normal at the vertex and converts it from local coordinates to global coordinates
                float3 lightDirection;                                          //Incident ray
                float attentuation;                                             //How the intensity of the light decays with distance

                if (0.0 == _WorldSpaceLightPos0.w)
                {
                   lightDirection = normalize(_WorldSpaceLightPos0.xyz);    //finds the incident ray between the light position and the vertex when light source is directional
                   attentuation = 1.0;                                      //directional lights have no attentuation
                }
                else
                {
                    float3 vertexToLight = normalize(_WorldSpaceLightPos0.xyz) - mul(modelMatrix, IN.vertex).xyz; //finds incident ray when light source is point light or spot light
                    float distance = length(vertexToLight);
                    attentuation = 1.0 / distance;
                    lightDirection = normalize(vertexToLight);
                }



                float angleOfReflection = max(0.0, dot(normalDirection, lightDirection)); //Finds the angle of reflection between the incident ray and the normal; I added this by separating out steps from the diffuse equation.

                float3 diffuseReflection = attentuation * _LightColor0.rgb * _Color.rgb * angleOfReflection; //Finds intensity of reflected ray (and therefore the colour of the vertex)

                OUT.col = float4(diffuseReflection, 1.0); //Colours are RGBA values, so diffuseReflection is the RGB and 1 is the alpha for opaque
                OUT.pos = UnityObjectToClipPos(IN.vertex);

                return OUT;
            }

            float4 FragmentFunc(v2f IN) : COLOR //This is where the shader assigns the colour to the fragment.
            {
                return IN.col;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"      //If Unity cannot read/understand our sub-shader it defaults to this built-in one.
}
