Shader "Custom/ShaderTest"
{
	//To learn Shader Basics I followed a tutorial on Youtube by Dapper Dino
	//URL: 
	//To learn how to turn off built-in lighting and supplement my own I followed a tutorial by J.P Doran
	//URL: https://tutorialedge.net/gamedev/unity/custom-diffuse-lighting-model-unity-tutorial/
	//Notes in comments are synthesized from that video.

    Properties //Properties are the public variables/parameters. They appear in the inspector.
    {
    	_Color ("Color", Color) = (1,1,1,1)
        //Spelling kepes consistent with Unity terms (no u); Colours need to be RGBA values and this is where the default goes.

        _MainTexture ("Texture", 2D) = "white"
        //The first entry is the name of the parameter in the inspector, the second is the kind; the equals white 
		//means that if a texture is not given then default to white
    }

    SubShader //Now we're making a sub-shader; this is where the shader can be altered for different hardware contexts
    {
    	Pass
    	{

    		//These are passes - they are the part of the shader that are run; you want as few passes as possible for speed.
			//Examples might be one pass for default, then another pass for shadow and another for highlights.
			//Shaders can also be written for cameras to apply filters to the whole screen.

    	    CGPROGRAM //This starts the commands in the shader programming language (HLSL/GLSL)

    	    //Define functions
	        #pragma vertex vertexFunc			//Vertex shader function takes the mesh
	        #pragma fragment fragmentFunc		//Fragment shader function tells pixels what colours the should be

	        #include "UnityCG.cginc"

	        struct appdata
	        {
	        	float4 vertex : POSITION;		//This is the position of the vertex we are currently working on
	        	float2 uv : TEXCOORD0;			// How to map the texture to the object
	        };

	        struct v2f							//This structure maps the vertex to fragment
	        {
	        	float4 position : SV_POSITION;	
	        	float2 uv : TEXCOORD0;
	        };

	        fixed4 _Color;						//Allows us to access properties from inspector in the shader
	        sampler2D _MainTexture;

	        v2f vertexFunc(appdata IN)			//Called on every vertex
	        {
	        	v2f OUT;
	        	OUT.position = UnityObjectToClipPos(IN.vertex);
	        	OUT.uv = IN.uv;
	        	return OUT;
	        }

	        fixed4 fragmentFunc(v2f IN) : SV_Target	//SV_Target is the screen/camera being used
	        {
	        	fixed4 pixelColour = tex2D(_MainTexture, IN.uv);
	        	return pixelColour;
	        }

	        ENDCG
	    }
    }

}
