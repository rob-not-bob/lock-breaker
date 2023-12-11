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
	var points_arc := PackedVector2Array()
	var from_angle := deg_to_rad(-180);
	var to_angle := deg_to_rad(0);
	var inner_radius = outer_radius * inner_to_outer_ratio;

	var get_point_on_circle = func(angle: float, radius: float) -> Vector2:
		return Vector2.from_angle(angle) * radius;

	var shackle_offset = Vector2(0, shackle_length);
	var offset = center + shackle_offset;

	points_arc.push_back(offset + get_point_on_circle.call(from_angle, inner_radius));
	points_arc.push_back(offset + get_point_on_circle.call(from_angle, outer_radius));

	var draw_arc_point := func(index: int, radius: float) -> void:
		var angle = from_angle + index * (to_angle - from_angle) / float(number_of_points);
		points_arc.push_back(center + get_point_on_circle.call(angle, radius));

	for i in range(number_of_points + 1):
		draw_arc_point.call(i, outer_radius);

	points_arc.push_back(offset + get_point_on_circle.call(to_angle, outer_radius));
	points_arc.push_back(offset + get_point_on_circle.call(to_angle, inner_radius));

	for i in range(number_of_points, -1, -1):
		draw_arc_point.call(i, inner_radius);

	draw_colored_polygon(points_arc, color)

func _draw():
	draw_shackle(
		Vector2(0, 0),
	);
