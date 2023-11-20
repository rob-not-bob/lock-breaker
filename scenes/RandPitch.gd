extends AudioStreamPlayer

@export_range(0.0, 4.0) var lowest_pitch = 1.0;
@export_range(0.0, 4.0) var highest_pitch = 1.0;

func _get_pitch() -> float:
	return randf_range(lowest_pitch, highest_pitch);

func play_random_pitch() -> void:
	pitch_scale = _get_pitch();
	play();
