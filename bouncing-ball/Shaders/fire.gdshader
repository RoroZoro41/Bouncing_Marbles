shader_type canvas_item;
uniform vec3 flame_color: source_color;
uniform float horizontal_scroll_speed = 0.0;
uniform float vertical_scroll_speed = 0.1;
uniform float opacity:hint_range(0.0, 1.0, 0.05) = 0.2;
uniform float UV_offset = 0;
uniform sampler2D noise: hint_default_black, repeat_enable;



void fragment() 
{
	vec2 moving_uv = vec2(
		UV.x + TIME * horizontal_scroll_speed, 
		UV.y + TIME * vertical_scroll_speed
		);
	vec4 noise_color = texture(noise, moving_uv);
	vec4 final_color = noise_color;
	final_color.rgb += vec3(UV.y + UV_offset);
	final_color.rgb = step(final_color.rgb, vec3(0.4));
	final_color.rgb = vec3(1.0) - final_color.rgb; 
	final_color.a = final_color.r * opacity;
	final_color.rgb = flame_color.rgb;
	COLOR = final_color;
}