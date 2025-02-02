shader_type canvas_item;
uniform vec4 color: source_color;
uniform sampler2D noise: hint_default_black, repeat_enable;
uniform float noise_uv_speed: hint_range(0.0, 1.0, 0.01);

void fragment() 
{
	vec2 nois_uv = vec2(UV.x + TIME * noise_uv_speed, UV.y + TIME * noise_uv_speed );
	vec4 noise_texture = texture(noise,nois_uv);
	vec4 final_color = noise_texture;
	final_color.a = sin(TIME * noise_uv_speed)+1.0;
	final_color *= color;
	COLOR = final_color;
}