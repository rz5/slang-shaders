#version 450

/*
    Mega Bezel - Creates a graphic treatment for the game play area to give a retro feel
    Copyright (C) 2019-2022 HyperspaceMadness - HyperspaceMadness@outlook.com

    Incorporates much great feedback from the libretro forum, and thanks 
    to Hunterk who helped me get started

    See more at the libretro forum
    https://forums.libretro.com/t/hsm-mega-bezel-reflection-shader-feedback-and-updates

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "common/globals-and-screen-scale-params.inc"
#include "common/helper-functions.inc"

layout(push_constant) uniform Push
{
	vec4 SourceSize;
	vec4 OriginalSize;
	vec4 OutputSize;
	uint FrameCount;
} params;

#include "../../../../include/compat_macros.inc"

#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;
layout(location = 1) out vec2 blur_dxdy;

void main()
{
	gl_Position = global.MVP * Position;
	vTexCoord = TexCoord;

	const vec2 dxdy_scale = global.SourceSize.xy * global.OutputSize.zw;
	blur_dxdy = dxdy_scale * global.SourceSize.zw;
}

#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 1) in vec2 blur_dxdy;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D MBZ_PostCRTPass;

#include "../../../../include/blur-functions.h"

void main()
{
   FragColor = HSM_Linearize(vec4(tex2Dblur9x9(MBZ_PostCRTPass, vTexCoord, blur_dxdy), 1), DEFAULT_CRT_GAMMA);
}