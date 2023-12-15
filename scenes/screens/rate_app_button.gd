extends TextureButton

func _on_button_up():
	var link := "https://play.google.com/store/apps/details?id=net.rcallen.LockBreaker";
	match OS.get_name():
		"Android":
			link = "https://play.google.com/store/apps/details?id=net.rcallen.LockBreaker";
		"iOS":
			link = "https://binarysunrise.dev/games/lock_breaker";

	OS.shell_open(link);
