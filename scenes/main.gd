extends SubViewport

var level_difficulty: int = 1;
var lock_difficulty: int = 1;

func show_game_over_screen(best_score: int):
	SceneSwitcher.change_scene("res://scenes/game_over_screen.tscn",
		{ "best_score": best_score }
	);

func _ready():
	level_difficulty = SceneSwitcher.get_param("difficulty", 1)
	lock_difficulty = level_difficulty;
	$lock.set_lock_difficulty(lock_difficulty);

func _on_lose(best_score):
	show_game_over_screen(best_score);
