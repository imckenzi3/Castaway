shader_type canvas_item;
//hint_screen_texture ;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise;
uniform sampler2D mask;
uniform float speed : hint_range(0.05, 0.5) = 0.1;
uniform float strength : hint_range(0.01, 0.5) = 0.1;

void fragment(){
	float noise_value = texture(noise, UV + TIME * speed).r;
	
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - (strength / 2.0) + vec2(noise_value) * strength);
	
	COLOR.a *= texture(mask, UV).a;
}