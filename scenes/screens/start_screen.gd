extends Control

signal start_button_clicked;
signal credit_button_clicked;

func _on_start_button_up():
	start_button_clicked.emit();

func _on_credits_button_up():
	credit_button_clicked.emit();
