extends Node2D

signal lock_lost(best_score: int);

@export var lock_difficulty: int = 1;
var current_difficulty: int = lock_difficulty;

func lock() -> Signal:
	$AnimationPlayer.play_backwards("unlock");
	return $AnimationPlayer.animation_finished;

func unlock() -> Signal:
	$AnimationPlayer.play("unlock");
	return $AnimationPlayer.animation_finished;

func lose() -> Signal:
	$AnimationPlayer.play("fail");
	return $AnimationPlayer.animation_finished;

func set_lock_difficulty(difficulty: int) -> void:
	lock_difficulty = difficulty;
	_set_difficulty(difficulty);


func _ready():
	var bgWidth = $lock_body/background.texture.get_width() * $lock_body/background.scale.x;
	var fgWidth = $lock_body/foreground.texture.get_width() * $lock_body/foreground.scale.x;
	
	var center = $lock_body/background.position;
	var trackWidth = (bgWidth - fgWidth) / 2;
	var radius = fgWidth / 2 + trackWidth / 2;
	
	$lock_body/track.initialize(center, radius, trackWidth);
	$lock_body/track.create_coin();

func _set_difficulty(difficulty: int):
	current_difficulty = difficulty;
	$lock_body/countdown.text = str(current_difficulty);

func _on_coin_collected():
	print("current_difficulty")
	if current_difficulty <= 0:
		return;
	_set_difficulty(current_difficulty - 1);

	if current_difficulty == 0:
		_on_win();
	else:
		$lock_body/track.create_coin();

func _on_win():
	var old_direction = $lock_body/track.direction;
	$lock_body/track.direction = 0;
	await unlock();
	await lock();
	set_lock_difficulty(lock_difficulty + 1);
	$lock_body/track.create_coin();
	$lock_body/track.direction = old_direction;

func _on_lose():
	await lose();
	lock_lost.emit(lock_difficulty - 1);
