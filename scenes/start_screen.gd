extends CanvasLayer

func _on_start_button_up():
	SceneSwitcher.change_scene("res://scenes/main.tscn");

func _on_quit_button_up():
	get_tree().quit();
