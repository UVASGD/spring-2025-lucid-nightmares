shader_type canvas_item;

// Background image to render.
uniform sampler2D image : filter_nearest, repeat_enable;
uniform sampler2D screen: hint_screen_texture;
uniform float intensity: hint_range(0.0, 1.0, 0.05) = 0.70;

// World position of vertices for fragment rendering.
varying vec2 world_pos;
varying vec4 vertex_color;



vec4 cround4(vec4 mat_row) { // custom round
	float round_amt = 2.0;
	return round(mat_row / round_amt) * round_amt / round_amt;
}

vec2 cround2(vec2 vec, float round_amt) { // custom round
	return round(vec / round_amt) * round_amt;
}

float float_mod(float f, float m) {
	return f - float(f / m);
}

vec2 vec2_mod(vec2 v, float m) {
	return vec2(float_mod(v.x, m), float_mod(v.y, m));
}


void vertex() {
	mat4 mat = MODEL_MATRIX;
	// Store world position of each vertex for fragment rendering.
	mat4 mm = mat4(cround4(mat[0]), cround4(mat[1]), 
				   cround4(mat[2]), cround4(mat[3]));
	world_pos = floor(VERTEX + (mm * vec4(VERTEX, 0.0, 1.0)).xy);
	vertex_color = COLOR;
}

void fragment() {
	vec2 scaled_pos = (UV + world_pos) / 256.0;
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 output_color = texture_color;
	vec3 img = texture(image, scaled_pos).rgb;
	vec4 intended_color = texture_color;
	vec4 secondary_color = vec4(vec3(0), 1);
	if (vertex_color != vec4(1.0, 1.0, 1.0, 1.0)) {
		intended_color = vertex_color;
		secondary_color = texture_color;
	}
	output_color = vec4(intended_color.rgb * intensity + secondary_color.rgb * (1.0 - intensity) 
	 - (img-1.0)/4.0*intensity,
	 intended_color.a * vertex_color.a);
	COLOR = output_color;
}