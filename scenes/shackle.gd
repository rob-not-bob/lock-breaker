@tool
extends Node2D

class_name Shackle;

@export_range(1, 128) var number_of_points: int = 32;
@export_range(0, 1, 0.01) var inner_to_outer_ratio = 0.72;
@export_range(0, 1000) var outer_radius: float = 147.0 * 3.5;
@export_range(0, 3000) var shackle_length: float = 200 * 3.5;
@export_color_no_alpha var color: Color = Color.html("#0A1719");

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw();

func draw_shackle(center: Vector2):
	var points_arc = PackedVector2Array()
	var from_angle = -90;
	var to_angle = 90;
	var inner_radius = outer_radius * inner_to_outer_ratio;

	var shackle_offset = Vector2(0, shackle_length);
	var point = deg_to_rad(from_angle - 90);
	points_arc.push_back(center + Vector2(cos(point), sin(point)) * inner_radius + shackle_offset);
	points_arc.push_back(center + Vector2(cos(point), sin(point)) * outer_radius + shackle_offset);

	for i in range(number_of_points + 1):
		var angle_point = deg_to_rad(from_angle + i * (to_angle - from_angle) / number_of_points - 90);
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * outer_radius);

	var point2 = deg_to_rad(to_angle - 90);
	points_arc.push_back(center + Vector2(cos(point2), sin(point2)) * outer_radius + shackle_offset);
	points_arc.push_back(center + Vector2(cos(point2), sin(point2)) * inner_radius + shackle_offset);

	for i in range(number_of_points, -1, -1):
		var angle_point = deg_to_rad(from_angle + i * (to_angle - from_angle) / number_of_points - 90);
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * inner_radius);

	draw_colored_polygon(points_arc, color)

func _draw():
	draw_shackle(
		Vector2(0, 0),
	);
