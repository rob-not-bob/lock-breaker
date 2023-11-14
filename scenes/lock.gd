extends Node2D

signal lock_lost(best_score: int);
signal lock_won(beaten_lock_difficulty: int);

@onready var bg: Sprite2D = $lock_body/background;
@onready var fg: Sprite2D = $lock_body/foreground;
@onready var track: Track = $lock_body/track;
@onready var countdown: Label = $lock_body/countdown;

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
	var bgWidth = bg.texture.get_width() * bg.scale.x;
	var fgWidth = fg.texture.get_width() * fg.scale.x;
	
	var center = bg.position;
	var trackWidth = (bgWidth - fgWidth) / 2;
	var radius = fgWidth / 2 + trackWidth / 2;
	
	track.initialize(center, radius, trackWidth);
	track.create_coin();

func _set_difficulty(difficulty: int):
	current_difficulty = difficulty;
	countdown.text = str(current_difficulty);

func _on_coin_collected():
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
	lock_won.emit(lock_difficulty);
	
	await unlock();
	await lock();
	
	set_lock_difficulty(lock_difficulty + 1);
	$lock_body/track.create_coin();
	$lock_body/track.direction = old_direction;

func _on_lose():
	await lose();
	lock_lost.emit(lock_difficulty - 1);
