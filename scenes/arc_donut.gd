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
@export var arc_angles: Array[float] = [21.6, 10.8, 5.4];
@export_range(0, 360, 0.1) var coyote_angle_size: float = 2.5;
@export var arc_colors: Array[Color] = [Color.html("#EE9B00"), Color.html("#CA6702"), Color.html("#AE2012")];
var arcs: Array[Arc] = [];
@export var reverse: bool = false;

var _sum: float = 0;

func _ready():
	_sum = 0;
	for i in range(arc_names.size()):
		arcs.push_back(Arc.new(arc_names[i], arc_colors[i], arc_angles[i]));
		_sum += arc_angles[i];

	arcs.push_back(Arc.new("none", bg_color, 360 - _sum));

	_sum += coyote_angle_size;

func _process(_delta):
	queue_redraw();

func _draw_arc(from_angle: float, arc: Arc):
	var arc_points := PackedVector2Array()
	var inner_radius: float = outer_radius * inner_to_outer_ratio;
	var to_angle := from_angle + arc.angle;

	var slope := (to_angle - from_angle) / number_of_points;
	var draw_arc_point := func(index: int, radius: float) -> void:
		var angle := deg_to_rad(slope * index + from_angle);
		arc_points.push_back(Vector2.from_angle(angle) * radius);

	for i in range(number_of_points + 1):
		draw_arc_point.call(i, outer_radius);

	for i in range(number_of_points, -1, -1):
		draw_arc_point.call(i, inner_radius);

	draw_colored_polygon(arc_points, arc.color);

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
	for i in len(arc_angles):
		var index = len(arc_angles) - i - 1 if reverse else i;
		var angle = arc_angles[index];
		total_angle += angle;
		if deg <= total_angle:
			return arc_names[index];

		var is_last_arc = i == len(arc_angles) - 1;
		if is_last_arc and deg <= (total_angle + coyote_angle_size):
			return arc_names[index];

	# Should never be called
	return null;

func _draw():
	var arc_start := start_angle;
	for arc in arcs:
		if reverse:
			arc_start -= arc.angle;

		_draw_arc(arc_start, arc);

		if not reverse:
			arc_start += arc.angle;

class Arc:
	var name: String;
	var color: Color;
	var angle: float;

	func _init(_name: String, _color: Color, _angle: float):
		self.name = _name;
		self.color = _color;
		self.angle = _angle;
