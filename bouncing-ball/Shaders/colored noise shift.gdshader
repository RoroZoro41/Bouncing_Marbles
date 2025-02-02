	shader_type canvas_item;
	uniform sampler2D noise: hint_default_black, repeat_enable;
	uniform float scroll_speed: hint_range(0.0, 1.0, 0.01);
	uniform float noise_alpha_deletion: hint_range(0.0, 1.0, 0.01);
	uniform float noise_alpha_swing_speed: hint_range(0.0, 1.0, 0.01);
	uniform vec4 color: source_color;

	void fragment()
	{
		//vec2 moving_noise = vec2(UV.x + TIME * sin(scroll_speed), UV.y + TIME * scroll_speed);
		vec2 moving_noise = vec2(UV.x + cos(TIME * scroll_speed), UV.y + sin(TIME * scroll_speed));
		vec4 noise_texture = texture(noise, moving_noise);
		
		//vec4 fading = vec4(vec3(sin(TIME)*0.5)+0.5 ,1.0);
		vec4 fading = vec4(vec3(sin(TIME)*0.25)+0.5 ,1.0);
		
		COLOR.a = step(noise_texture.r, (sin(TIME * noise_alpha_swing_speed) + 1.0) * 0.5 * noise_alpha_deletion);
		
		fading = vec4(abs(sin(TIME*scroll_speed)),abs(cos(TIME*scroll_speed)),abs(sin(TIME*scroll_speed)),1.0 );
		
		COLOR *= fading;
		//COLOR *= noise_texture;
	}