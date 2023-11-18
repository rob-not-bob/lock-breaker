@tool
extends Node2D

class_name ArcDonut;

@export_range(1, 128) var number_of_points: int = 32;
@export_range(0, 1, 0.01) var inner_to_outer_ratio = 0.72;
@export_range(0, 1000) var outer_radius: float = 294 * 3.5;
@export_color_no_alpha var bg_color: Color = Color.html("#0A1719");

@export_category("Arcs")
@export_range(0, 360) var start_angle: float = 0;
@export var arc_names: Array[String] = ["yellow", "orange", "red"];
@export var angle_sizes: Array[float] = [21.6, 10.8, 5.4];
@export var colors: Array[Color] = [Color.html("#EE9B00"), Color.html("#CA6702"), Color.html("#AE2012")];

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw();

func _draw_arc_donut_about_point(center: Vector2, from_angle: float, to_angle: float, color: Color):
	var points_arc = PackedVector2Array()
	var inner_radius = outer_radius * inner_to_outer_ratio;

	for i in range(number_of_points + 1):
		var angle_point = deg_to_rad(from_angle + i * (to_angle - from_angle) / number_of_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * outer_radius)

	for i in range(number_of_points, -1, -1):
		var angle_point = deg_to_rad(from_angle + i * (to_angle - from_angle) / number_of_points - 90);
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * inner_radius);

	draw_colored_polygon(points_arc, color);

## Returns the name of the arc at _deg
func get_arc_name_at(_deg: float):
	var deg = fmod(_deg, 360);
	print("deg ", deg)
	if deg < start_angle:
		return null;

	var total_angle = start_angle;
	for i in len(angle_sizes):
		var angle = angle_sizes[i];
		total_angle += angle;
		print("angle ", total_angle)
		if deg <= total_angle:
			return arc_names[i];

	return null;

func _draw():
	var angle_start = start_angle;
	for i in len(angle_sizes):
		var angle = angle_sizes[i];
		_draw_arc_donut_about_point(Vector2(0, 0),
			angle_start, angle_start + angle,
			colors[i],
		);
		angle_start += angle;

	_draw_arc_donut_about_point(Vector2(0, 0), angle_start, 360 + start_angle, bg_color);
