shader_type canvas_item;
uniform float cirlce_size = 1.0;

void fragment()
{
	COLOR.gb = SCREEN_UV;
}

void vertex()
{
	VERTEX *= abs(cirlce_size);
}