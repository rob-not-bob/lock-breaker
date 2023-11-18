extends Node2D

signal lock_lost(best_score: int);
signal lock_won(beaten_lock_difficulty: int, new_speed: float);

@onready var arc_donut: ArcDonut = $lock_body/arc_donut;
@onready var track: Track = $lock_body/track;
@onready var countdown: Label = $lock_body/countdown;

@export_group("Lock Difficulty")
@export var lock_difficulty: int = 1:
	set(difficulty):
		lock_difficulty = difficulty;
		current_difficulty = lock_difficulty;
	get:
		return lock_difficulty;

@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		track.rotation_speed = lock_speed;
	get:
		return lock_speed;

@export_group("Coin Spawn Distance")
@export var first_coin_spawn_distance: float = PI;
@export var min_coin_spawn_distance: float = PI / 3:
	set(spawn_distance):
		min_coin_spawn_distance = spawn_distance;
		$lock_body/track/coin_spawner.min_coin_spawn_distance = min_coin_spawn_distance;
	get:
		return min_coin_spawn_distance;

var current_difficulty: int = lock_difficulty:
	set(difficulty):
		current_difficulty = difficulty;
		countdown.text = str(current_difficulty);
	get:
		return current_difficulty;

func lock() -> Signal:
	# $AnimationPlayer.play_backwards("unlock");
	return $AnimationPlayer.animation_finished;

func unlock() -> Signal:
	# $AnimationPlayer.play("unlock");
	return $AnimationPlayer.animation_finished;

func lose() -> Signal:
	# $AnimationPlayer.play("fail");
	return $AnimationPlayer.animation_finished;

func _ready():
	var center = arc_donut.position;
	var inner_radius = arc_donut.outer_radius * arc_donut.inner_to_outer_ratio;
	var trackWidth = (arc_donut.outer_radius - inner_radius) / 2;
	var radius = (inner_radius + arc_donut.outer_radius) / 2;
	
	track.initialize(center, radius, trackWidth);
	track.create_coin(first_coin_spawn_distance);

func _on_coin_collected():
	if current_difficulty <= 0:
		return;
	current_difficulty -= 1;

	if current_difficulty == 0:
		_on_win();
	else:
		track.create_coin();

func _on_win():
	var old_direction = track.direction;
	track.direction = 0;
	
	await unlock();
	await lock();

	lock_difficulty += 1;
	if lock_difficulty % 3 == 0:
		lock_speed += 0.125;

	lock_won.emit(lock_difficulty, lock_speed);

	track.create_coin(first_coin_spawn_distance);
	track.direction = old_direction;

func _on_lose():
	await lose();
	lock_lost.emit(lock_difficulty - 1);
