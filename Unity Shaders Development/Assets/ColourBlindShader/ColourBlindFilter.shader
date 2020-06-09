Shader "ColourBlindFilter"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Mode("Mode", Int) = 0

	}
		SubShader
		{
			// No culling or depth
			//Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				uniform sampler2D _MainTex;
				float _Mode;

				fixed3x3 GetColourBlindMatrix(int ColourBlindMode)
				{
					if (_Mode == 0)
						return fixed3x3(
							1, 0, 0,
							0, 1, 0,
							0, 0, 1);

					if (_Mode == 1)
						return fixed3x3(
							0.56667, 0.55833, 0,
							0.43333, 0.44167, 0.24167,
							0, 0, 0.75833);

					if (_Mode == 2)
						return fixed3x3(
							0.81667, 0.33333, 0,
							0.18333, 0.66667, 0.125,
							0, 0, 0.875);

					if (_Mode == 3)
						return fixed3x3(
							0.625, 0.7, 0,
							0.375, 0.3, 0.3,
							0, 0, 0.7);

					if (_Mode == 4)
						return fixed3x3(
							0.8, 0, 0,
							0.2, 0.25833, 0.14167,
							0, 0.74167, 0.85833);

					if (_Mode == 5)
						return fixed3x3(
							0.95, 0, 0,
							0.05, 0.43333, 0.475,
							0, 0.56667, 0.525);

					if (_Mode == 6)
						return fixed3x3(
							0.96667, 0, 0,
							0.03333, 0.73333, 0.18333,
							0, 0.26667, 0.81667);

					if (_Mode == 7)
						return fixed3x3(
							0.299, 0.299, 0.299,
							0.587, 0.587, 0.587,
							0.114, 0.114, 0.114);

					if (_Mode == 8)
						return fixed3x3(
							0.618, 0.163, 0.163,
							0.32, 0.775, 0.32,
							0.062, 0.062, 0.516);

					return fixed3x3(1, 0, 0,
						0, 1, 0,
						0, 0, 1);

				}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				fixed3x3 CBM = GetColourBlindMatrix(_Mode);
				
				col.r = (col.r * CBM[0][0] + col.g * CBM[1][0] + col.b * CBM[2][0]);
				col.g = (col.r * CBM[0][1] + col.g * CBM[1][1] + col.b * CBM[2][1]);
				col.b = (col.r * CBM[0][2] + col.g * CBM[1][2] + col.b * CBM[2][2]);

				return col;
			}
			ENDCG
		}
		}
		
}
