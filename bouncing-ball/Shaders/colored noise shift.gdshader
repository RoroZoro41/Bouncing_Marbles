	shader_type canvas_item;
	uniform sampler2D noise: hint_default_black, repeat_enable;
	uniform float scroll_speed: hint_range(0.0, 1.0, 0.01);
	uniform float noise_alpha_deletion: hint_range(0.0, 1.0, 0.01);
	uniform float noise_alpha_swing_speed: hint_range(0.0, 1.0, 0.01);
	uniform float noise_color_mix_speed: hint_range(0.0, 2.0, 0.01);

void fragment()
{
	//vec2 moving_noise = vec2(UV.x + TIME * sin(scroll_speed), UV.y + TIME * scroll_speed);
	vec2 moving_noise = vec2(UV.x + cos(TIME * scroll_speed), UV.y + sin(TIME * scroll_speed));
	vec4 noise_texture = texture(noise, moving_noise);
	
	//vec4 fading = vec4(vec3(sin(TIME)*0.25)+0.5 ,1.0);
	vec4 fading = vec4(vec3(sin(TIME* noise_color_mix_speed )+1.0)*0.5 ,1.0);
	fading.rgb = mix(vec3(0.1), vec3(0.3), fading.rgb); 
	
	//the noise cutout
	COLOR.a = step(noise_texture.r, (sin(TIME * noise_alpha_swing_speed) + 1.0) * 0.5 * noise_alpha_deletion);
	
//	fades between colors
	//fading = vec4(abs(sin(TIME*scroll_speed)),abs(cos(TIME*scroll_speed)),abs(sin(TIME*scroll_speed)),1.0 );
	
	COLOR *= fading;
	//COLOR = fading;
}