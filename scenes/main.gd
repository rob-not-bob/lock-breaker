extends SubViewport

var lock_difficulty: int = 1;
var current_speed: float = 3.0;

func show_game_over_screen(best_score: int):
	SceneSwitcher.change_scene("res://scenes/screens/game_over_screen.tscn",
		{ "best_score": best_score }
	);

func load_game():
	var use_game_data = SceneSwitcher.get_param("use_game_data", false);

	if use_game_data:
		var game_state = GameSaver.load_game();
		if game_state.has("lock_difficulty"):
			lock_difficulty = GameSaver.game_state.lock_difficulty;
		if game_state.has("current_speed"):
			current_speed = GameSaver.game_state.current_speed;

	$lock.lock_difficulty = lock_difficulty;
	$lock.lock_speed = current_speed;

func _ready():
	load_game();

func _on_lock_beat(new_lock_difficulty: int, new_speed: float):
	GameSaver.game_state = {
		"lock_difficulty": new_lock_difficulty,
		"current_speed": new_speed,
	};
	GameSaver.save_game();

func _on_lose(best_score: int):
	print('lost', best_score)
	show_game_over_screen(best_score);
