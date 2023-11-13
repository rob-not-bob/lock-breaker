extends Node2D

signal info_calculated(center: Vector2, trackWidth: float, trackCenter: float);

func _ready():
	var bgWidth = $lock_body/background.texture.get_width() * $lock_body/background.scale.x;
	var fgWidth = $lock_body/foreground.texture.get_width() * $lock_body/foreground.scale.x;
	
	var center = $lock_body/background.global_position;
	var trackWidth = (bgWidth - fgWidth) / 2;
	var radius = fgWidth / 2 + trackWidth / 2;
	
	info_calculated.emit(center, radius, trackWidth);

func lock() -> Signal:
	$AnimationPlayer.play_backwards("unlock");
	return $AnimationPlayer.animation_finished;

func unlock() -> Signal:
	$AnimationPlayer.play("unlock");
	return $AnimationPlayer.animation_finished;
