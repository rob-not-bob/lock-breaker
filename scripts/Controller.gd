class_name GameController
extends Node

@export var lock: Lock;
@export var indicator: Indicator;

signal missed_arcs;
signal selected_arc(arc_name: String);

func _process(_delta) -> void:
	_handle_debug_controls();
	_handle_direction_change();
	_check_for_passive_loss();


func init() -> void:
	previous_arc = null;
	indicator.initialize(
		lock.global_position,
		lock.get_orbit_radius(),
		lock.get_track_width(),
	);
	indicator.direction = T.Direction.NONE;
	indicator.rotation = randf_range(0, 2 * PI);


func restart() -> void:
	previous_arc = null;


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
		_missed_arcs();
	else:
		previous_arc = null;
		selected_arc.emit(arc_name);

# We lose when we've passed we've passed all the arcs
var previous_arc = null;
func _check_for_passive_loss() -> void:
	if indicator.direction == T.Direction.NONE:
		return;

	var indicator_over_arc = lock.get_arc_at(rad_to_deg(indicator.rotation));

	if not previous_arc and indicator_over_arc:
		previous_arc = indicator_over_arc;
	elif previous_arc and not indicator_over_arc:
		_missed_arcs();

func _missed_arcs():
	previous_arc = null;
	missed_arcs.emit();
