extends Node2D

signal lock_lost(best_score: int);
signal lock_won(beaten_lock_difficulty: int, new_speed: float);
signal crit;

@onready var arc_donut: ArcDonut = $lock_body/arc_donut;
@onready var indicator: Indicator = $lock_body/indicator;
@onready var countdown: Label = $lock_body/countdown;

@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		indicator.rotation_speed = lock_speed;

@export_group("Arc Spawn Distance")
@export var first_spawn_distance: float = 90;
@export var min_spawn_distance: float = 60;

@onready var score: int = 0:
	set(difficulty):
		score = max(0, difficulty);
		countdown.text = str(score);
		if score < 100:
			countdown.add_theme_font_size_override("font_size", 260);
		elif score >= 100:
			countdown.add_theme_font_size_override("font_size", 190);
		elif score >= 1000:
			countdown.add_theme_font_size_override("font_size", 145);

var was_between: bool = false;

func _ready():
	var init_indicator := func():
		var center := arc_donut.position;
		var inner_radius: float = arc_donut.outer_radius * arc_donut.inner_to_outer_ratio;

		var trackWidth := (arc_donut.outer_radius - inner_radius) / 2.0;
		var orbitRadius := (inner_radius + arc_donut.outer_radius) / 2.0;

		indicator.initialize(center, orbitRadius, trackWidth);

	init_indicator.call();
	reset();


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		indicator.direction = 0 if indicator.direction != 0 else 1;
	if Input.is_key_pressed(KEY_LEFT):
		indicator.rotation -= deg_to_rad(1);
	if Input.is_key_pressed(KEY_RIGHT):
		indicator.rotation += deg_to_rad(1);

	if indicator.direction == 0:
		return;

	var angle = rad_to_deg(indicator.rotation);
	var current_arc = arc_donut.get_arc_name_at(angle);

	if Input.is_action_just_pressed("invert"):
		indicator.direction *= -1;

		printt("angle", "arc", "d_angle");
		printt(angle, current_arc, arc_donut.start_angle);
		if current_arc:
			_on_score(current_arc);
			lock_speed = 2.0 + 0.125 * int(score / 5.0);
		else:
			_on_lose();

	if was_between:
		if not arc_donut.get_arc_name_at(angle):
			_on_lose();
	elif arc_donut.get_arc_name_at(angle):
			was_between = true;


func reset() -> void:
	score = 0;
	lock_speed = 2.0;
	was_between = false;

	indicator.direction = 1;
	_choose_new_start_angle();


func set_theme(theme) -> void:
	arc_donut.bg_color = theme.donut.bg;
	arc_donut.arc_colors.clear();
	arc_donut.arc_colors.append_array(theme.donut.arcs);

	countdown.modulate = theme.countdown;
	indicator.modulate = theme.indicator;

	$shackle.color = theme.shackle;
	$shackle.queue_redraw();


func lock() -> Signal:
	# $AnimationPlayer.play_backwards("unlock");
	return $AnimationPlayer.animation_finished;


func unlock() -> Signal:
	# $AnimationPlayer.play("unlock");
	return $AnimationPlayer.animation_finished;


func lose() -> Signal:
	# $AnimationPlayer.play("fail");
	return $AnimationPlayer.animation_finished;


func _on_score(current_arc):
	if current_arc == "red":
		score += 3;
		crit.emit();
	elif current_arc == "orange":
		score += 2;
	else:
		score += 1;

	was_between = false;

	_choose_new_start_angle();


func _choose_new_start_angle():
	var angle = rad_to_deg(indicator.rotation);
	arc_donut.reverse = indicator.direction == -1;
	arc_donut.start_angle = randf_range(
		angle + min_spawn_distance,
		angle + 360 - min_spawn_distance
	);


func _on_lose():
	indicator.direction = 0;
	lock_lost.emit(score);
