extends Node2D

class_name MyUtils

static func get_position_about_point(point: Vector2, radius: float, angle: float):
	var x = radius * cos(angle);
	var y = radius * sin(angle);
	return point + Vector2(x, y);


func draw_arc_donut_about_point(point: Vector2, radius: float, from_angle: float, to_angle: float, color: Color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(point)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(from_angle + i * (to_angle - from_angle) / nb_points - 90)
		points_arc.push_back(point + Vector2(cos(angle_point), sin(angle_point)) * radius)

	draw_polygon(points_arc, colors)
