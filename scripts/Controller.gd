extends Node

@export var lock: Lock;
@export var indicator: Indicator;
@export var score_label: Label;

# TODO: Move
@export var min_spawn_distance: float = 60;

# TODO: Move
@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		indicator.rotation_speed = lock_speed;

# TODO: Move
var score := 0:
	set(new_score):
		score = new_score;
		score_label.text = str(score);
		if score < 100:
			score_label.add_theme_font_size_override("font_size", 260);
		elif score >= 100:
			score_label.add_theme_font_size_override("font_size", 190);
		elif score >= 1000:
			score_label.add_theme_font_size_override("font_size", 145);


func _process(_delta):
	_handle_debug_controls();
	_handle_direction_change();
	_check_for_passive_loss();


func init():
	score = 0;
	indicator.initialize(
		lock.global_position,
		lock.get_orbit_radius(),
		lock.get_track_width(),
	);
	indicator.direction = T.Direction.NONE;
	indicator.rotation = randf_range(0, 2 * PI);
	_choose_lock_angle();


func start():
	indicator.direction = T.Direction.CLOCKWISE;


func reset():
	score = 0;
	previous_arc = null;
	indicator.direction = T.Direction.CLOCKWISE;
	_choose_lock_angle();


var paused := false;
var previous_direction = T.Direction.NONE;
func _handle_debug_controls() -> void:
	if not OS.is_debug_build():
		return;

	if Input.is_action_just_pressed("pause"):
		paused = !paused;
		if paused:
			previous_direction = indicator.direction as T.Direction;
			indicator.direction = T.Direction.NONE;
		else:
			indicator.direction = previous_direction;
	if Input.is_key_pressed(KEY_LEFT):
		indicator.rotation -= deg_to_rad(1);
	if Input.is_key_pressed(KEY_RIGHT):
		indicator.rotation += deg_to_rad(1);


func _handle_direction_change() -> void:
	if not Input.is_action_just_pressed("invert"):
		return;

	var arc_name = lock.get_arc_at(rad_to_deg(indicator.rotation));
	indicator.direction *= -1;

	printt("arc name", arc_name);
	if not arc_name:
		_lose();
	else:
		_update_score(arc_name);
		_choose_lock_angle();
		previous_arc = null;
		_scale_difficulty();

# TODO: Move
func _update_score(arc_name: String) -> void:
	score += _get_point_value(arc_name);

# TODO: Move
func _get_point_value(arc_name: String) -> int:
	match arc_name:
		'red':
			return 3;
		'orange':
			return 2;
		'yellow':
			return 1;
		_:
			return 0;


# We lose when we've passed we've passed all the arcs
var previous_arc = null;
func _check_for_passive_loss() -> void:
	var indicator_over_arc = lock.get_arc_at(rad_to_deg(indicator.rotation));

	if not previous_arc and indicator_over_arc:
		previous_arc = indicator_over_arc;
	elif previous_arc and not indicator_over_arc:
		_lose();


func _lose():
	indicator.direction = T.Direction.NONE;
	print('lose');


func _choose_lock_angle() -> void:
	var angle = rad_to_deg(indicator.rotation);
	lock.reverse = indicator.direction == T.Direction.COUNTER_CLOCKWISE;
	lock.angle = randf_range(
		angle + min_spawn_distance,
		angle + 360 - min_spawn_distance
	);

# TODO: Move
func _scale_difficulty():
	lock_speed = 2.0 + 0.125 * int(score / 5.0);
