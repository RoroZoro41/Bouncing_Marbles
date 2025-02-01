shader_type canvas_item;

void fragment()
{
	vec2 xy = vec2(abs(UV.x-0.5), abs(UV.y-0.5));
	COLOR.rg = xy;
	float grayscale = length(xy) * 2.0; // Scale to reach full range
	COLOR =  vec4(vec3(grayscale), 1.0);
}