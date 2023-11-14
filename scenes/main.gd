extends SubViewport

var level_difficulty: int = 1;
var lock_difficulty: int = 1;

func show_game_over_screen(best_score: int):
	SceneSwitcher.change_scene("res://scenes/game_over_screen.tscn",
		{ "best_score": best_score }
	);

func load_game():
	var game_state = GameSaver.load_game();
	if game_state.has("current_difficulty"):
		level_difficulty = GameSaver.game_state.current_difficulty;

	lock_difficulty = level_difficulty;
	$lock.set_lock_difficulty(lock_difficulty);

func _ready():
	load_game();

func _on_lock_beat(lock_difficulty: int):
	GameSaver.game_state = {"current_difficulty": lock_difficulty + 1};
	GameSaver.save_game();

func _on_lose(best_score: int):
	show_game_over_screen(best_score);
