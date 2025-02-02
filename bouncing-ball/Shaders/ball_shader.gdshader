shader_type canvas_item;

//uniform sampler2D texture : hint_albedo;
uniform vec4 marble_color : source_color = vec4(1.0, 1.0, 1.0, 0.8); // Color of the marble (can adjust transparency)
uniform float refraction_strength : hint_range(0.0, 1.0) = 0.05; // Refraction strength
uniform vec2 refraction_distortion = vec2(0.02, 0.02); // Distortion of refraction

void fragment() {
    // Get the base texture color
    vec4 tex_color = texture(TEXTURE, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);

    //// Calculate refraction effect
    //vec2 refraction_offset = (FRAGCOORD.xy / SCREEN_PIXEL_SIZE) * refraction_strength * refraction_distortion;
    //vec4 refraction_color = texture(TEXTURE, (FRAGCOORD.xy / SCREEN_PIXEL_SIZE) + refraction_offset);
//
    //// Mix the texture and refraction colors
    //vec4 final_color = mix(tex_color, refraction_color, 0.5);
//
    //// Apply marble color and transparency
    //final_color *= marble_color;
    //final_color.a *= tex_color.a; // Keep the alpha channel from the texture
//
    //// Set the final color of the fragment
    //COLOR = final_color;
	
	COLOR = texture(TEXTURE, UV)*0.1;
	
}
