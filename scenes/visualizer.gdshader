shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float PULSE_SIZE : hint_range(0.0, 2.0, 0.005) = 1.0;
uniform float spectrum_sample_point: hint_range(0.0, 1.0, 0.05) = 0.8; 

global uniform sampler2D spectrum_texture;

// Bind's time between a value of 0 and 1 linearly
// Repeats every x seconds
float time_shaper(float x) {
	return (1.0 / x) * mod(TIME, x);
}

// zooms in on the center of uv by zoom
// zoom is the amount of zoom i.e. 2 for 2x zoom
vec2 centered_zoom(vec2 uv, float zoom) {
	return uv * (1.0 / zoom) + ((zoom - 1.0) / 2.0) / zoom;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	float spectrum_value = texture(spectrum_texture, vec2(spectrum_sample_point, 0)).r;
	float zoom_size = 1.0 + spectrum_value * PULSE_SIZE;

	// COLOR = texture(spectrum_texture, UV);

	COLOR = texture(SCREEN_TEXTURE, centered_zoom(uv, zoom_size));
}

