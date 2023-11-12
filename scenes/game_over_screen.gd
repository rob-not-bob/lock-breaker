extends CanvasLayer

func _on_quit_button_up():
	get_tree().quit();

func _on_try_again_button_up():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
