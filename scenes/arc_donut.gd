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
@export var reverse: bool = false;

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
		var sum = 0;
		for angle in angle_sizes:
			sum += angle;
		arc_start = 360 - sum;

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
	var sum = 0;
	for angle in angle_sizes:
		sum += angle;
	
	var end_angle = start_angle - sum if reverse else start_angle + sum;
	if end_angle < 0:
		end_angle = 360 + end_angle;
	end_angle = fmod(end_angle, 360);

	return end_angle;

func _ready():
	print("281: ", get_arc_name_at(281)); # null)
	print("351: ", get_arc_name_at(351)); # yellow)
	print("5: ", get_arc_name_at(5)); # yellow)
#	print("0: ", get_arc_name_at(0)); # yellow
#	print("360: ", get_arc_name_at(360)); # yellow
#	print("10: ", get_arc_name_at(10)); # yellow
#	print("30: ", get_arc_name_at(30)); # orange
#	print("32.4: ", get_arc_name_at(32.4)); # orange
#	print("32.5: ", get_arc_name_at(32.5)); # red
#	print("37.8: ", get_arc_name_at(37.8)); # red
#	print("37.9: ", get_arc_name_at(37.9)); # none
#	print("394.8: ", get_arc_name_at(394.8)); # red
#	print("------------------------------");
#	print("0: ", get_arc_name_at(0)); # null
#	print("360: ", get_arc_name_at(360)); # null
#	print("350: ", get_arc_name_at(350)); # yellow
#	print("330: ", get_arc_name_at(330)); # orange
#	print("327.6: ", get_arc_name_at(327.6)); # orange
#	print("327.5: ", get_arc_name_at(327.5)); # red
#	print("322.2: ", get_arc_name_at(322.2)); # red
#	print("322.1: ", get_arc_name_at(322.1)); # none

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
