extends Control

signal tap_to_resume_clicked();

func _on_tap_to_resume_button_pressed() -> void:
	tap_to_resume_clicked.emit();
