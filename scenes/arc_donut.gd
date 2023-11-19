@tool
extends Node2D

class_name ArcDonut;

@export_range(1, 128) var number_of_points: int = 32;
@export_range(0, 1, 0.01) var inner_to_outer_ratio = 0.72;
@export_range(0, 1000) var outer_radius: float = 294 * 3.5;
@export_color_no_alpha var bg_color: Color = Color.html("#0A1719");

@export_category("Arcs")
@export_range(0, 360) var start_angle: float = 0:
	set(angle):
		if angle < 0:
			angle = 360 + angle;
		start_angle = fmod(angle, 360);
	get:
		return start_angle;
@export var arc_names: Array[String] = ["yellow", "orange", "red"];
@export var angle_sizes: Array[float] = [21.6, 10.8, 5.4];
@export var colors: Array[Color] = [Color.html("#EE9B00"), Color.html("#CA6702"), Color.html("#AE2012")];
@export var reverse: bool = false;

var _sum: float = 0;

func _ready():
	_sum = 0;
	for angle in angle_sizes:
		_sum += angle;

func _process(_delta):
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
	var deg = _deg;
	if _deg < 0:
		deg *= -1;
	deg = fmod(_deg, 360);

	# Manipulate deg to be relative to start_angle so
	# our code still works no matter rotation
	deg = deg - start_angle;
	if deg < 0:
		deg = 360 + deg;

	var arc_start = 0;
	if reverse:
		arc_start = 360 - _sum;

	if deg < arc_start:
		return null;

	var total_angle = arc_start;
	for i in len(angle_sizes):
		var index = len(angle_sizes) - i - 1 if reverse else i;
		var angle = angle_sizes[index];
		total_angle += angle;
		if deg <= total_angle:
			return arc_names[index];

	# Should never be called
	return null;

func get_start_angle():
	return start_angle;

func get_end_angle():
	var end_angle = start_angle - _sum if reverse else start_angle + _sum;
	if end_angle < 0:
		end_angle = 360 + end_angle;
	end_angle = fmod(end_angle, 360);

	return end_angle;

func _draw():
	var angle_start = start_angle;
	for i in len(angle_sizes):
		var angle = -angle_sizes[i] if reverse else angle_sizes[i];
		_draw_arc_donut_about_point(Vector2(0, 0),
			angle_start, angle_start + angle,
			colors[i],
		);
		angle_start += angle;

	if reverse:
		_draw_arc_donut_about_point(Vector2(0, 0), start_angle, 360 + angle_start, bg_color);
	else:
		_draw_arc_donut_about_point(Vector2(0, 0), angle_start, 360 + start_angle, bg_color);
