shader_type canvas_item;
//
//uniform bool active = false;
//
//void fragment() {
//	vec4 previous_color = texture(TEXTURE, UV);
//	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
//	vec4 new_color = previous_color;
//	if (active == true) {
//		new_color = white_color;
//	}
//	COLOR = new_color;
//}
uniform bool active = false;
void fragment(){
	vec4 main_texture = texture(TEXTURE, UV);
	
	if (active == true) {
	float percentage_of_color = abs(sin(TIME * 4.0));
	main_texture.r = max(percentage_of_color, main_texture.r);
	main_texture.g = max(percentage_of_color, main_texture.g);
	main_texture.b = max(percentage_of_color, main_texture.b);
	
	
		//main_texture = texture(TEXTURE, UV);
//		new_color = white_color;
	}
	
	COLOR = main_texture;
}