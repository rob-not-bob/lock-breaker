extends TextureButton


func _on_pressed():
	Input.action_press("invert");
	Input.action_release("invert");
