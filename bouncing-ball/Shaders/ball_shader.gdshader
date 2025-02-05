shader_type canvas_item;

uniform vec4 marble_color : source_color = vec4(1.0, 1.0, 1.0, 0.8); // Color of the marble (can adjust transparency)
uniform float cirlce_size = 1.0;
//uniform sampler2D noise_sample: repeat_enable;

uniform sampler2D noise_sample: hint_default_black, repeat_enable;
uniform float scroll_speed: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float distortion_strength: hint_range(-1.0, 1.0, 0.1) = 0.2;

void fragment() 
{
	vec4 noise_color = texture(noise_sample, UV + scroll_speed * TIME);
	vec4 screen_color = texture(screen_texture,
		SCREEN_UV + distortion_strength * noise_color.rr);
	COLOR = screen_color;
}
//uniform float noise_alpha_deletion: hint_range(0.0, 2.0, 0.01);
//uniform float noise_alpha_swing_speed: hint_range(0.0, 1.0, 0.01);
//uniform float screen_distortion_strength = 0.1;
//// Bind the current screen as a texture.
//void fragment()
//{
	//vec2 moving_noise = vec2(UV.x + cos(TIME * scroll_speed), UV.y + sin(TIME * scroll_speed));
	//
	//vec4 noise_texture = texture(noise, moving_noise);
	//vec4 image = texture(TEXTURE,UV);
	//vec4 fading = vec4(vec3(sin(TIME)+1.0)*0.5 ,1.0);
	//fading.rgb = mix(vec3(0.1), vec3(0.3), fading.rgb); 
	//
	////the noise cutout
	//COLOR.a *= step(noise_texture.r, (sin(TIME * noise_alpha_swing_speed) + 1.0) * 0.5 * noise_alpha_deletion);
	//
	//vec4 screen_color = texture(screen_texture,
		//SCREEN_UV + 1.0 * noise_texture.rr);
	//
	//COLOR *= image;
//}

void vertex()
{
	VERTEX *= abs(cirlce_size);
}