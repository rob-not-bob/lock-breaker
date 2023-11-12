extends SubViewport

var level_difficulty = 1;
var lock_difficulty = 1;

func show_game_over_screen():
	SceneSwitcher.change_scene("res://scenes/game_over_screen.tscn",
		{ "best_score": max(level_difficulty - lock_difficulty, level_difficulty - 1)}
	);

func _ready():
	var difficulty = SceneSwitcher.get_param("difficulty")
	if difficulty:
		level_difficulty = difficulty;

	lock_difficulty = level_difficulty;
	$lock/countdown.text = str(lock_difficulty);
	$track.create_coin();

func _on_lock_info_calculated(center, radius, trackWidth):
	$track.initialize(center, radius, trackWidth);

func _on_coin_collected():
	if lock_difficulty <= 0:
		return;

	lock_difficulty -= 1;
	$lock/countdown.text = str(lock_difficulty);
	if lock_difficulty == 0:
		$track.direction = 0;
		await $lock.unlock();
		SceneSwitcher.change_scene("res://scenes/main.tscn", { "difficulty": level_difficulty + 1 })
	else:
		$track.create_coin();

func _on_lose():
	print("lose")
	show_game_over_screen();
