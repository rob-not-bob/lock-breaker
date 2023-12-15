class_name Lock
extends Node2D

@onready var arc_donut: ArcDonut = $lock_body/arc_donut;

@export var angle: float = 0:
	set(_angle):
		arc_donut.start_angle = _angle;
		angle = _angle;
@export var reverse: bool = false:
	set(_reverse):
		arc_donut.reverse = _reverse;
		reverse = _reverse;

func _ready():
	Themes.theme_set.connect(func(theme) -> void:
		$shackle.color = theme.shackle;
		$shackle.queue_redraw();
	);

func get_orbit_radius() -> float:
	return (arc_donut.inner_radius + arc_donut.outer_radius) / 2.0;


func get_track_width() -> float:
	return (arc_donut.outer_radius - arc_donut.inner_radius) / 2.0;


func get_arc_at(_angle):
	return arc_donut.get_arc_name_at(_angle);


func lock() -> Signal:
	# $AnimationPlayer.play_backwards("unlock");
	return $AnimationPlayer.animation_finished;


func unlock() -> Signal:
	# $AnimationPlayer.play("unlock");
	return $AnimationPlayer.animation_finished;


func lose() -> Signal:
	# $AnimationPlayer.play("fail");
	return $AnimationPlayer.animation_finished;
