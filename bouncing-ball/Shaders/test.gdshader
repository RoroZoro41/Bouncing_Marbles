shader_type canvas_item;
//#363d52
//54 61 82
//0.212 0.239 0.322
uniform vec4 color_picker: source_color;
void fragment() 
{
	vec4 image = texture(TEXTURE, UV);
	vec4 original_image = image;
	image.a *= step(0.4, image.b);
	image.a *= step(image.r, 0.68);
	image.rgb = vec3(1.0);
		//image.b = (1.0);
	//image *= color_picker;
	vec4 image_mask = vec4(1.0) - image;
	image_mask.rgb = original_image.rgb;
	image.rgb = image_mask.rgb * image.rgb;
	COLOR = image; 
	//COLOR.rgb *= vec3(1.0,1.0,0.0);
}
