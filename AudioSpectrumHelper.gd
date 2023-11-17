extends Node

@export_range(0, 10) var Multiplier: float;

const VU_COUNT = 1;
const FREQ_MAX = 11050.0

const MIN_DB = 60

@export var lerp_smoothing: float = 4;
var lerped_spectrum: Array[float];
var spectrum;
var image_texture: ImageTexture;
var image: Image;

@export var num_previous_samples: int = 5;
var average_sample: float = 0.01;

# Called when the node enters the scene tree for the first time.
func _ready():
	lerped_spectrum.resize(VU_COUNT);
	image = Image.create(VU_COUNT, 1, false, Image.FORMAT_RGB8);
	for i in VU_COUNT:
		image.set_pixel(i, 0, Color.BLACK);
	image_texture = ImageTexture.create_from_image(image);
	RenderingServer.global_shader_parameter_set("spectrum_texture", image_texture);
	spectrum = AudioServer.get_bus_effect_instance(1,0)

# From https://www.youtube.com/watch?v=bTj5xQfyyIQ
func _process(_delta):
	# music_process(delta);
	pass

func music_process(delta):
	#warning-ignore:integer_division
	var prev_hz = 0
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var effect = energy * Multiplier;
		prev_hz = hz
		
		var this_sample_loudness = effect / (lerped_spectrum[i-1] + 0.0001);
		lerped_spectrum[i-1] = lerp(lerped_spectrum[i-1], this_sample_loudness, delta * lerp_smoothing);
		
		print(lerped_spectrum[i-1], " , ", this_sample_loudness);
		# average_sample = (average_sample * (num_previous_samples - 1) + lerped_spectrum[i-1]) / num_previous_samples;

		# lerped_spectrum[i-1] = lerp(lerped_spectrum[i-1], effect, delta * lerp_smoothing);
		# image.set_pixel(i - 1, 0, Color.WHITE * lerped_spectrum[i-1]);
		image.set_pixel(i - 1, 0, Color.WHITE * lerped_spectrum[i-1]);

	image_texture.update(image);
