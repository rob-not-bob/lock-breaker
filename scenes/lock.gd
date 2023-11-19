extends Node2D

signal lock_lost(best_score: int);
signal lock_won(beaten_lock_difficulty: int, new_speed: float);

@onready var arc_donut: ArcDonut = $lock_body/arc_donut;
@onready var indicator: Indicator = $lock_body/indicator;
@onready var countdown: Label = $lock_body/countdown;

@export_group("Lock Difficulty")
@export var lock_difficulty: int = 0:
	set(difficulty):
		lock_difficulty = difficulty;
	get:
		return lock_difficulty;

@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		indicator.rotation_speed = lock_speed;
	get:
		return lock_speed;

@export_group("Coin Spawn Distance")
@export var first_spawn_distance: float = 180;
@export var min_spawn_distance: float = 60;

@onready var current_difficulty: int = lock_difficulty:
	set(difficulty):
		current_difficulty = max(0, difficulty);
		countdown.text = str(current_difficulty);
	get:
		return current_difficulty;

var was_between: bool = false;
var start_angle: float = 0;
var end_angle: float = 0;

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
	current_difficulty = lock_difficulty;
	
	indicator.initialize(center, radius, trackWidth);
	indicator.current_angle = deg_to_rad(arc_donut.start_angle + first_spawn_distance - 90);
	indicator.direction = -1 if arc_donut.reverse else 1;
	was_between = false;

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		indicator.direction = 0 if indicator.direction != 0 else 1;
	if Input.is_key_pressed(KEY_LEFT):
		indicator.current_angle -= deg_to_rad(1);
	if Input.is_key_pressed(KEY_RIGHT):
		indicator.current_angle += deg_to_rad(1);

	var angle = rad_to_deg(indicator.current_angle) + 90;
	var current_arc = arc_donut.get_arc_name_at(angle);

	if Input.is_action_just_pressed("invert"):
		indicator.direction *= -1;

		printt("angle", "arc", "d_angle");
		printt(angle, current_arc, arc_donut.start_angle);
		if current_arc:
			_on_coin_collected(current_arc);

	if indicator.direction == 0:
		return;

	if was_between:
		if not arc_donut.get_arc_name_at(angle):
			_on_lose();
	elif arc_donut.get_arc_name_at(angle):
			was_between = true;

func _on_coin_collected(current_arc):
	if current_arc == "red":
		current_difficulty += 2;
	else:
		current_difficulty += 1;

	was_between = false;

	var angle = rad_to_deg(indicator.current_angle) + 90;
	arc_donut.reverse = indicator.direction == -1;
	arc_donut.start_angle = randf_range(
		angle + min_spawn_distance,
		angle + 360 - min_spawn_distance
	);

# func _on_win():
#	var old_direction = indicator.direction;
#	indicator.direction = 0;
#	
#	await unlock();
#	await lock();

#	lock_difficulty += 1;
#	if lock_difficulty % 3 == 0:
#		lock_speed += 0.125;

#	lock_won.emit(lock_difficulty, lock_speed);

#	indicator.direction = old_direction;
#	arc_donut.start_angle = indicator.current_angle + first_spawn_distance + 90;
#	arc_donut.reverse = indicator.direction == -1;

func _on_lose():
	indicator.direction = 0;
	# await lose();
	# lock_lost.emit(lock_difficulty);
