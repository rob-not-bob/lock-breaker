extends TextureButton

var master: int;
func _ready():
	master = AudioServer.get_bus_index("Master");
	EventBus.mute.connect(func(__is_muted):
		_update_mute_texture();
	);

func _is_muted() -> bool:
	return AudioServer.is_bus_mute(master);

func _toggle_mute() -> bool:
	AudioServer.set_bus_mute(master, !_is_muted());
	return _is_muted();

func _update_mute_texture() -> void:
	texture_normal = load(
		"res://assets/audioOff.png" if _is_muted() else "res://assets/audioOn.png"
	);

func _on_mute_button_up():
	var is_muted = _toggle_mute();
	EventBus.mute.emit(is_muted);
