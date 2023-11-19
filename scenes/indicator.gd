extends Node2D

class_name Indicator

@export var rotation_speed: float = 2.5;

var _center: Vector2 = Vector2.ZERO;
var _radius: float = 0;

func initialize(center: Vector2, radius: float, track_width: float, start_angle: float = 0):
	_radius = radius;
	_center = center;
	current_angle = start_angle;
	_set_sizes(track_width);

var current_angle: float = 0;
var direction = 1;

func _set_sizes(track_width: float):
	var pixel_size = float($Sprite2D.texture.get_size().x);
	var ratio = (track_width - 10) / pixel_size;
	scale = Vector2(ratio, ratio) * 2.0;

func _physics_process(delta):
	current_angle += rotation_speed * direction * delta;
	current_angle = fmod(current_angle, 2 * PI)
	position = MyUtils.get_position_about_point(_center, _radius, current_angle);
	rotation = current_angle;
