﻿Shader "Custom/IRtoNone"
{
	Properties
	{
		_HiColor ("Max Temp Color", Color) = (0,0.5,0,1)
		_LowColor ("Min Temp Color", Color) = (0,0,1,1)
		_MaxDist("Max Distance", Range(0.01,1000)) = 8.0
		_MinDist("Min Distance", Range(0.01,1000)) = 2.0
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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

//			sampler2D _MainTex;
//			float4 _MainTex_ST;
			half4 _HiColor;
			half4 _LowColor;
			float _MaxDist;
			float _MinDist;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float dist=i.vertex.w;
				float aux=clamp(0.0, 1.0, (dist-_MinDist)/(_MaxDist-_MinDist));
				half4 auxCol=_LowColor*aux+ _HiColor*(1-aux);
				aux=clamp(0.0, 1.0, (dist-_MaxDist)/_MaxDist);
				return auxCol*(1-aux);
			}
			ENDCG
		}
	}
}
