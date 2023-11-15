extends Node2D

class_name Track

@export var rotation_speed: float = 2.5;

signal lost;
signal coin_collected;

var _center: Vector2 = Vector2.ZERO;
var _radius: float = 0;

func initialize(center: Vector2, radius: float, track_width: float, start_angle: float = 0):
	_radius = radius;
	_center = center;
	current_angle = start_angle;
	$coin_spawner.calculate_coin_scale(track_width);

func lose():
	direction = 0;
	lost.emit();

func invert_direction():
	if direction == 0:
		return;

	direction *= -1;
	if not coin.in_coin:
		lose();
	else:
		coin.collect_coin();
		coin_collected.emit();

var current_angle: float = 0;
var direction = 1;

func _physics_process(delta):
	current_angle += rotation_speed * direction * delta;
	$indicator.position = MyUtils.get_position_about_point(_center, _radius, current_angle);
	$indicator.rotation = current_angle;

func _process(_delta):
	if Input.is_action_just_pressed("invert"):
		invert_direction();

var coin: Coin;
func create_coin(spawn_distance_override = null):
	coin = $coin_spawner.spawn_coin(_center, _radius, current_angle, spawn_distance_override);
	coin.connect("coin_missed", lose)
