Shader "Custom/Sasha-BlinnPhong"
{
    Properties
    {
        _Color("Diffuse Color", Color) = (1,1,1,1)
        _SpecColor("Specular Colour", Color) = (1,1,1,1)
        _DiffuseCoefficient("k-diffuse", Float) = 0
        _SpecularCoefficient("k-specular", Float) = 0
        _Shininess("alpha-Shininess", Float) = 10
    }
        SubShader
    {
        Pass    //First pass for ambient lighting and directional light sources
        {
            Tags { "LightMode" = "ForwardBase" }  //This makes sure all uniforms are correctly set

            CGPROGRAM

            #pragma vertex VertexFunc       //Vertex function for per-vertex shading
            #pragma fragment FragmentFunc   //Fragment function for fragment colour calculation

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;    //Colour of light source
            uniform float4 _Color;          //Colour of material from shader inspector
            uniform float4 _SpecColor;
            uniform float _DiffuseCoefficient;
            uniform float _SpecularCoefficient;
            uniform float _Shininess;

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
                float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, IN.vertex).xyz);   //Obeserver vector

                float3 halfDirection = normalize(viewDirection + lightDirection);

                float angleOfReflection = dot(normalDirection, lightDirection); //Finds the angle of reflection between the incident ray and the normal; I added this by separating out steps from the diffuse equation.

                float3 ambientReflection;
                float3 diffuseReflection;
                float3 specularReflection;


                ambientReflection = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb; //Calculating the ambient lighting intensity/colour

                diffuseReflection = _DiffuseCoefficient * attentuation * _LightColor0.rgb * _Color.rgb * max(0.0, angleOfReflection); //Finds intensity of reflected ray (and therefore the colour of the vertex)

                if (angleOfReflection < 0.0)
                {
                    specularReflection = float3 (0.0, 0.0, 0.0);
                }
                else
                {
                    float angle = max(0.0, dot(normalDirection, halfDirection));
                    specularReflection = _SpecularCoefficient * attentuation * _LightColor0.rgb * _SpecColor.rgb * pow(angle, _Shininess);
                }

                OUT.col = float4(ambientReflection + diffuseReflection + specularReflection, 1.0); //Total intensity for phong shading is the sum of the ambient, diffuse, and specular reflections
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
                //Pass for additional light sources - no ambient contribution in this pass
                Tags { "LightMode" = "ForwardAdd" }
                Blend One One //Additive Blending

                CGPROGRAM

                #pragma vertex VertexFunc       //Vertex function for per-vertex shading
                #pragma fragment FragmentFunc   //Fragment function for fragment colour calculation

                #include "UnityCG.cginc"

                uniform float4 _LightColor0;    //Colour of light source
                uniform float4 _Color;          //Colour of material from shader inspector
                uniform float4 _SpecColor;
                uniform float _DiffuseCoefficient;
                uniform float _SpecularCoefficient;
                uniform float _Shininess;

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
                    float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, IN.vertex).xyz);   //Obeserver vector

                    float3 halfDirection = normalize(viewDirection + lightDirection);

                    float3 diffuseReflection;
                    float3 specularReflection;

                    float angleOfReflection = dot(normalDirection, lightDirection); //Finds the angle of reflection between the incident ray and the normal; I added this by separating out steps from the diffuse equation.

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

                    if (angleOfReflection < 0.0)
                    {
                        specularReflection = float3 (0.0, 0.0, 0.0);
                    }
                    else
                    {
                        float angle = max(0.0, dot(normalDirection, halfDirection));
                        specularReflection = _SpecularCoefficient * attentuation * _LightColor0.rgb * _SpecColor.rgb * pow(angle, _Shininess);
                    }

                    diffuseReflection = _DiffuseCoefficient * attentuation * _LightColor0.rgb * _Color.rgb * max(0.0, angleOfReflection); //Finds intensity of reflected ray (and therefore the colour of the vertex)

                    OUT.col = float4(diffuseReflection + specularReflection, 1.0); //Colours are RGBA values, so diffuseReflection is the RGB and 1 is the alpha for opaque
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
    FallBack "Specular"
}
