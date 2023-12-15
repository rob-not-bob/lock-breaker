extends MarginContainer


func _ready():
	if not Utils.is_mobile():
		return;

	var safeAreaRect: Rect2i = DisplayServer.get_display_safe_area();
	var displaySize: Vector2i = DisplayServer.window_get_size();

	add_theme_constant_override("margin_top", safeAreaRect.position.y);
	add_theme_constant_override("margin_right", maxi(displaySize.x - safeAreaRect.end.x, 0));
	add_theme_constant_override("margin_bottom", maxi(displaySize.y - safeAreaRect.end.y, 0));
	add_theme_constant_override("margin_left", safeAreaRect.position.x);


	# DebugUI.log("Safe Area Rect\n-----------------------");
	# DebugUI.log("Pos: %s" % safeAreaRect.position);
	# DebugUI.log("Size: %s" % safeAreaRect.size);
	# DebugUI.log("End: %s" % safeAreaRect.end);
	# DebugUI.log("Display Size: %s" % displaySize);
	# DebugUI.log("%s %s %s %s" % [
	# 	safeAreaRect.position.y,
	# 	displaySize.x - safeAreaRect.end.x,
	# 	displaySize.y - safeAreaRect.end.y,
	# 	safeAreaRect.position.x
	# ]);

