Shader "Custom/LowLight"
{
	Properties
	{
		_HiColor ("Max Color", Color) = (0.2,1,0.2,1)
		_MidColor ("Mid Color", Color) = (0.1,.75,0.1,1)
		_LowColor ("Low Color", Color) = (0.05,0.1,0.05,1)
		_MidValue("Value which intensitiy is middle color", range(1.0,0.0))= 0.8
		_MainTex ("Texture", 2D) = "white" {}
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
			half4 _MidColor;
			half4 _LowColor;
			float _MidValue;

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
				fixed4 col = tex2D(_MainTex, i.uv) * (i.diff*0.5+0.5);
				float mag=length(col.rgb);

				float aux=clamp(0, _MidValue, mag);
				half4 auxCol=_MidColor*aux+_LowColor*(1-aux);
				aux=clamp(_MidValue, 0.95, mag);
				return auxCol*(1-aux)+_HiColor*aux;
			}
			ENDCG
		}
	}
}
