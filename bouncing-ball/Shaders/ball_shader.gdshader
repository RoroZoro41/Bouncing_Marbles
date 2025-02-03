shader_type canvas_item;

uniform vec4 marble_color : source_color = vec4(1.0, 1.0, 1.0, 0.8); // Color of the marble (can adjust transparency)

void fragment() 
{
	vec4 image = texture(TEXTURE,UV);
	//if (image.a < 1.0)
		//image.a = 0.0;
	//COLOR.a = step(image.a, 0.4);
	image *= vec4(0.0,1.0,0.0,1.0);
	image.a = 0.5;
	COLOR.rgb = image.rgb;
}
