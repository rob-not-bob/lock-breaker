class_name Indicator
extends Node2D

@export var rotation_speed: float = 2.5;

var _center: Vector2 = Vector2.ZERO;
var _radius: float = 0;

func initialize(center: Vector2, radius: float, track_width: float, start_angle: float = 0):
	_radius = radius;
	_center = center;
	rotation = start_angle;
	_set_sizes(track_width);

var direction: int = T.Direction.CLOCKWISE;

func _set_sizes(track_width: float):
	var pixel_size := float($Sprite2D.texture.get_size().x);
	var ratio := (track_width - 10) / pixel_size;
	scale = Vector2(ratio, ratio) * 2.0;

func _physics_process(delta):
	rotation += rotation_speed * direction * delta;
	position = _center + _radius * Vector2.from_angle(rotation);
