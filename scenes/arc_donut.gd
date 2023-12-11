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
@export var arc_names: Array[String] = ["yellow", "orange", "red"];
@export var angle_sizes: Array[float] = [21.6, 10.8, 5.4];
@export_range(0, 360, 0.1) var coyote_angle_size: float = 2.5;
@export var colors: Array[Color] = [Color.html("#EE9B00"), Color.html("#CA6702"), Color.html("#AE2012")];
@export var reverse: bool = false;

var _sum: float = 0;

func _ready():
	_sum = 0;
	for angle in angle_sizes:
		_sum += angle;
	_sum += coyote_angle_size;

func _process(_delta):
	queue_redraw();

func _draw_arc_about_point(center: Vector2, from_angle: float, to_angle: float, color: Color):
	var points_arc = PackedVector2Array()
	var inner_radius = outer_radius * inner_to_outer_ratio;

	var draw_arc_point := func(index: int, radius: float) -> void:
		var angle_point = deg_to_rad(from_angle + index * (to_angle - from_angle) / number_of_points - 90);
		points_arc.push_back(center + Vector2.from_angle(angle_point) * radius);

	for i in range(number_of_points + 1):
		draw_arc_point.call(i, outer_radius);

	for i in range(number_of_points, -1, -1):
		draw_arc_point.call(i, inner_radius);

	draw_colored_polygon(points_arc, color);

## Returns the name of the arc at _deg
func get_arc_name_at(_deg: float):
	# Manipulate deg to be relative to start_angle so
	# our code still works no matter rotation
	var deg = _deg - start_angle;
	deg = fmod(deg, 360);
	if deg < 0:
		deg += 360;

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

		var is_last_arc = i == len(angle_sizes) - 1;
		if is_last_arc and deg <= (total_angle + coyote_angle_size):
			return arc_names[index];

	# Should never be called
	return null;

func _draw():
	var angle_start = start_angle;
	for i in len(angle_sizes):
		var angle = -angle_sizes[i] if reverse else angle_sizes[i];
		_draw_arc_about_point(Vector2(0, 0),
			angle_start, angle_start + angle,
			colors[i],
		);
		angle_start += angle;

	if reverse:
		_draw_arc_about_point(Vector2(0, 0), start_angle, 360 + angle_start, bg_color);
	else:
		_draw_arc_about_point(Vector2(0, 0), angle_start, 360 + start_angle, bg_color);
