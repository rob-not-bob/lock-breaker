shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float PULSE_SIZE : hint_range(0.0, 2.0, 0.005) = 1.0;
uniform float BPM = 120;

// Shaping function with rapid falloff
// https://iquilezles.org/articles/functions/
// The larger the value of k, the shorter the pulse
float expImpulse(float x, float k) {
    float h = k*x;
    return h*exp(1.0-h);
}

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
	float BPS = BPM / 60.0;
	float zoom_size = PULSE_SIZE * expImpulse(time_shaper(1.0 / BPS), 8.) + 1.0;

	COLOR = texture(SCREEN_TEXTURE, centered_zoom(uv, zoom_size));
}

