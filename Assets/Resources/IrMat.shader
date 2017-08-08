Shader "Custom/IrMat"
{
	Properties
	{
		_HiColor ("Max Temp Color", Color) = (1,1,0,1)
		_LowColor ("Min Temp Color", Color) = (0.5,0,0,1)
		_DistDampener("Distance Dampener", float) = 50.0
		_glowFactor("Glow Factor", float) = 0.01
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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
			fixed4 _HiColor;
			fixed4 _LowColor;
			float _glowFactor;
			
			v2f vert (appdata v)
			{
				v2f o;
				float4 v2= float4(v.norm.x, v.norm.y,v.norm.z,0)*_glowFactor ;
				o.vertex = UnityObjectToClipPos(v.vertex+v2);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				half3 worldNormal = mul ((float3x3)UNITY_MATRIX_IT_MV, v.norm);
				o.diff.r=worldNormal.z;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.b=col.b/2;
				float mag = length(col)*pow(i.diff.r,4);
				col = _HiColor*mag+_LowColor*(1-mag);

				return col;
			}
			ENDCG
		}
	}
}
