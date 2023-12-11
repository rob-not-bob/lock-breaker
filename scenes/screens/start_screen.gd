extends Control

signal start_button_clicked;
signal credit_button_clicked;
signal mute_button_clicked(isMuted: bool);

func _set_mute_texture(isMuted: bool) -> void:
	$MarginContainer/Mute.texture_normal = load(
		"res://assets/audioOff.png" if isMuted else "res://assets/audioOn.png"
	);

func _on_start_button_up():
	start_button_clicked.emit();

func _on_mute_button_up():
	var master = AudioServer.get_bus_index("Master");
	var muted = AudioServer.is_bus_mute(master);

	_set_mute_texture(!muted);
	AudioServer.set_bus_mute(master, !muted);
	
	mute_button_clicked.emit(!muted);


func _on_credits_button_up():
	credit_button_clicked.emit();
