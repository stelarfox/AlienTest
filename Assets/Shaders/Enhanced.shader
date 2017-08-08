Shader "Custom/Enhanced"
{
	Properties
	{
		_HiColor ("Max Temp Color", Color) = (1,1,1,1)
		_LowColor ("Min Temp Color", Color) = (0,0,0,1)
		_MainTex ("Texture", 2D) = "white" {}
		_TotOff  ("Full Size of a transition", Range(2.0,10.0)) = 5.0
		_PartOff ("Size of a Interference", Range(1.0,5.0)) = 2.0
		_RandTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
//		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				half3 norm : NORMAL;
			};
  			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 diff : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half4 _HiColor;
			half4 _LowColor;
			float _TotOff;
			float _PartOff;
			sampler2D _RandTex;
			float4 _RandTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				half3 worldNormal = UnityObjectToWorldNormal(v.norm);
				o.diff = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                // factor in the light color
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float4 col2= tex2D(_RandTex, float2(i.vertex.x/_ScreenParams.x, i.vertex.y/_ScreenParams.y));
//				float mag2=(col2.r+col2.g+col2.b)/3.0;
				float mag2=0.0;
				fixed4 col = tex2D(_MainTex, i.uv) * i.diff;
				float mag=clamp(0.0,1.0,length(col.rgb)*(0.9+mag2*0.2));

//				float aux=clamp(0.0, 1.0, 1-pow(1-mag,2));
				float aux=mag;
				return _HiColor*aux+_LowColor*(1-aux);
			}
			ENDCG
		}
	}
}
