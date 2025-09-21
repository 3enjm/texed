shader_type canvas_item;
uniform vec4 colour : source_color = vec4(1.0);
uniform float scale : hint_range(0, 10.0) = 1.;
uniform float grid_intensity : hint_range(0.1, 1.0) = 0.7;

float grid (vec2 fragCoord, float space, float gridWidth)
{
	vec2 p = fragCoord;// - vec2(1.5);
	vec2 size = vec2(gridWidth);
	
	vec2 a1 = mod(p - size, space);
	vec2 a2 = mod(p + size, space);
	vec2 a = a2 - a1;
	
	float g = min(a.x, a.y);
	return g;//clamp(g, 0.5, 1.0);
}

void fragment() 
{	
	vec4 col = colour;
	float line = clamp(grid(UV.xy*-512.*scale, 64.0, 1.0), 0.0, 1.);
	if (line > 0.5) { discard; }
	col.xyz *= clamp(grid(UV.xy*-512.*scale, 64.0, 1.0), grid_intensity, 1.);
	
	COLOR = vec4(col.r, col.g, col.b, 1.0);
}