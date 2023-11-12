extends Node2D

@export var rotation_speed: float = 2.5;


signal lost;

var _center: Vector2 = Vector2.ZERO;
var _radius: float = 0;

func initialize(center: Vector2, radius: float, track_width: float):
	_radius = radius;
	_center = center;
	calculate_coin_scale(track_width)

func get_position_about_center(angle: float):
	var x = _radius * cos(angle);
	var y = _radius * sin(angle);
	return _center + Vector2(x, y);

func lose():
	direction = 0;
	lost.emit();

func invert_direction():
	direction *= -1;
	if not in_coin:
		lose();
	else:
		collect_coin();

func _ready():
	spawn_coin();

var current_angle: float = 0;
var direction = 1;
func _process(delta):
	if Input.is_action_just_pressed("invert"):
		invert_direction();

	current_angle += rotation_speed * direction * delta;
	$indicator.global_position = get_position_about_center(current_angle);
	$indicator.rotation = current_angle;


@export var min_coin_spawn_distance = PI / 4;
@onready var coin_scene = preload("res://scenes/coin.tscn");

signal coin_collected;

var _coin_scale: float = 1;
func calculate_coin_scale(_track_width: float):
	_coin_scale = 1;
	
var coin = null;
func spawn_coin():
	coin = coin_scene.instantiate();
	coin.global_position = get_position_about_center(-min_coin_spawn_distance);
	coin.global_position = get_position_about_center(randf_range(
		current_angle + min_coin_spawn_distance,
		current_angle + 2 * PI - min_coin_spawn_distance
	));
	coin.connect("coin_entered", _on_coin_entered);
	coin.connect("coin_exited", _on_coin_exited);
	$coin_parent.add_child(coin);

func collect_coin():
	coin.disconnect("coin_exited", _on_coin_exited)
	coin.queue_free();
	coin_collected.emit();
	spawn_coin();

var in_coin = false;
func _on_coin_entered(_area: Area2D):
	in_coin = true;

func _on_coin_exited(_area: Area2D):
	in_coin = false;
	if coin:
		lose();
