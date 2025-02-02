	shader_type canvas_item;

	void fragment()
	{
		vec2 xy = vec2(abs(UV.x-0.5), abs(UV.y-0.5));
		COLOR.rg = xy;
		float grayscale = length(xy); // Scale to reach full range
		COLOR =  vec4(vec3(grayscale), 1.0);
		COLOR.a = COLOR.r;
		float shift = sin(TIME * 0.5) * 0.5 + 0.5; // Oscillates between 0 and 1
		COLOR.rgb = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), shift);
		COLOR = (COLOR * length(COLOR))*0.5;
		//COLOR.rgb = vec3(0.5);
	}