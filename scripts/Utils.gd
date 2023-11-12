extends Node

class_name MyUtils

static func get_position_about_point(point: Vector2, radius: float, angle: float):
	var x = radius * cos(angle);
	var y = radius * sin(angle);
	return point + Vector2(x, y);
