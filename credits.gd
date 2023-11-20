extends Control

signal on_back_clicked;

func _on_back_button_up():
	on_back_clicked.emit();
