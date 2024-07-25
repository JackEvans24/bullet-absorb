shader_type spatial;

uniform float x_rotation_speed = 0.6;
uniform float x_repetitions = 2.0;
uniform vec2 spacing = vec2(2.0, 2.0);
uniform float y_offset_distance = 0.2;
uniform float y_offset_speed = 0.2;
uniform float y_static_offset = 0.1;

uniform sampler2D surface_texture;
uniform vec3 emission_colour;
uniform float emission_strength;
uniform float base_transparency = 0.4;

float add_spacing(float val, float spacing_coefficient) {
	return max(val * spacing_coefficient - (1.0 / spacing_coefficient), 0.0);
}

float get_spaced(float uv_x, float magnifier) {
	float adjustment = 0.5 * magnifier - 0.5;
	return clamp(magnifier * uv_x - adjustment, 0.0, 1.0);
}

void fragment() {
	float x_offset = TIME * x_rotation_speed;
	float translated_x = get_spaced(fract(UV.x * x_repetitions + x_offset), spacing.x);

	float y_offset = sin(TIME * PI * y_offset_speed) * y_offset_distance + y_static_offset;
	float translated_y = get_spaced(fract(UV.y) + y_offset, spacing.y);

	vec2 translated_uv = vec2(translated_x, translated_y);
	vec4 texture_result = texture(surface_texture, translated_uv);

	float use_texture = step(texture_result.r, 0.1) * step(0.1, texture_result.a);
	float use_source = 1.0 - use_texture;

	ALBEDO = vec3(1.0) * use_texture;
	ALPHA = base_transparency * use_source + 1.0 * use_texture;
	EMISSION = emission_colour * use_texture;
}
