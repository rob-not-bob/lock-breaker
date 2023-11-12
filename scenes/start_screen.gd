extends CanvasLayer

func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/main.tscn");

func _on_quit_button_up():
	get_tree().quit();
