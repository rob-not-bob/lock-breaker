extends Node2D

@export var min_coin_spawn_distance = PI / 4;
@onready var coin_scene = preload("res://scenes/coin.tscn");

var _coin_scale: float = 1;
func calculate_coin_scale(_track_width: float):
	_coin_scale = 1;
	
var coin = null;
func spawn_coin(center: Vector2, radius: float, angle: float):
	coin = coin_scene.instantiate();

	coin.global_position = MyUtils.get_position_about_point(center, radius, -min_coin_spawn_distance);
	coin.global_position = MyUtils.get_position_about_point(center, radius, randf_range(
		angle + min_coin_spawn_distance,
		angle + 2 * PI - min_coin_spawn_distance
	));

	add_child(coin);

	return coin;
